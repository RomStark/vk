//
//  CollectionViewController.swift
//  vk
//
//  Created by Al Stark on 10.05.2023.
//

import UIKit

final class CollectionViewController: UIViewController {

    private var humanList: [Human] = []
    
   
    private var semophore = DispatchSemaphore(value: 1)
    private var sick = 0 {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self else {return}
                self.sickCountLabel.text = "Количество больных: \(self.sick)"
                self.notSickCountLabel.text = "Количество здоровых: \(self.count - self.sick)"
            }
        }
    }
    
    let globalBackgroundSyncronizeDataQueue = DispatchQueue(label: "queueLabels")
    
    
    var sickCount: Int {
        set(newValue){
//            semophore.wait()
            self.sick = newValue
//            semophore.signal()
            
//            globalBackgroundSyncronizeDataQueue.sync(){
//                self.sick = newValue
//                DispatchQueue.main.async {
//                    self.sickCountLabel.text = "Количество больных: \(newValue)"
//                    self.notSickCountLabel.text = "Количество здоровых: \(newValue)"
//                }
//
//            }
        }
        get{
            return sick
        }
    }
    
    private var count = 0
   
    private var infectionFactor = 0
    private var collectionView: UICollectionView!
    
    private let sickCountLabel: UILabel = {
        let label = UILabel()
        label.text = "Количество больных: 0"
        return label
    }()
    
    private let notSickCountLabel: UILabel = {
        let label = UILabel()
        label.text = "Количество здоровых: "
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    func configure(count: Int, time: Int, infectionFactor: Int) {
        for _ in 0..<count {
            humanList.append(Human())
        }
        self.count = count
        self.infectionFactor = infectionFactor
        self.notSickCountLabel.text = "Количество здоровых: \(count)"
       
        _ = Timer.scheduledTimer(timeInterval: TimeInterval(time), target: self, selector: #selector(fire), userInfo: nil, repeats: true)
         
        
        
    }
    @objc func fire() {
        var start = 0
        var end = 100
        while end < count {
            createQueue(start: start, end: end)
            start += 100
            end += 100
        }
        createQueue(start: start, end: count)
    }
    
    private func createQueue(start: Int, end: Int) {
        let queue = DispatchQueue(label: "queueTime", attributes: .concurrent)
        for i in start..<end {
            if humanList[i].isSick && check(index: i) {
                queue.async { [weak self] in
                    guard let self else { return }
                    var mass: [IndexPath] = []
                    for _ in 0..<self.infectionFactor {
                        let x = Int.random(in: -1...1)
                        let y = Int.random(in: -1...1)
                        if x == y && y == 0 {
                            continue
                        }
                        let humanIndex = i + x + y * 10
                        self.semophore.wait()
                        if self.checkIndex(humanIndex: humanIndex, currentIndex: i) {
                            
                            self.sickCount += 1
                            self.humanList[humanIndex].isSick = true
                            let index = IndexPath(row: humanIndex, section: 0)
                            mass.append(index)
                        }
                        self.semophore.signal()
                    }
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadItems(at: mass)
                    }
                }
            }
        }
    }
    
    private func checkIndex(humanIndex: Int, currentIndex: Int) -> Bool{
        if humanIndex < 0 {
            return false
        }
        if humanIndex >= self.count {
            return false
        }
        if self.humanList[humanIndex].isSick {
            return false
        }
        if (abs(humanIndex % 10 - currentIndex % 10) > 1) {
            return false
        }
        return true
        
    }
    
    private func check(index: Int) -> Bool {
        let indexes = [index + 1, index - 1, index - 10, index + 10, index + 11, index + 9, index - 11, index - 9]
        let filterIndexes = indexes.filter {  $0 < self.count && $0 > -1 }
        var count = 0
        for i in filterIndexes {
            if humanList[i].isSick == false {
                count += 1
            }
        }
        
        return count != 0
        
    }

}

private extension CollectionViewController {
    func setupUI() {
        setupLabels()
        setupCollectionView()
        
    }
    func setupLabels() {
        view.addSubview(sickCountLabel)
        sickCountLabel.translatesAutoresizingMaskIntoConstraints = false
        sickCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        sickCountLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        
        view.addSubview(notSickCountLabel)
        
        notSickCountLabel.translatesAutoresizingMaskIntoConstraints = false
        notSickCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        notSickCountLabel.topAnchor.constraint(equalTo: sickCountLabel.bottomAnchor, constant: 10).isActive = true
    }
    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupFlowLayout())
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: notSickCountLabel.bottomAnchor, constant: 10).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(HumanCollectionViewCell.self, forCellWithReuseIdentifier: HumanCollectionViewCell.reuseIdentifier)
    }
    
    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = .init(width: 30, height: 30)
//        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        layout.minimumLineSpacing = 7
        layout.minimumInteritemSpacing = 7
        
        layout.sectionInset = .init(top: 7, left: 7, bottom: 7, right: 7)
        
        return layout
    }
}

//MARK: UICollectionViewDelegate
extension CollectionViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if humanList[indexPath.row].isSick != true {
            humanList[indexPath.row].isSick = true
            
            
            sickCount += 1
            
            
            self.collectionView.reloadItems(at: [indexPath])
        }
        
    }
    
}

//MARK: UICollectionViewDataSource
extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return humanList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HumanCollectionViewCell.reuseIdentifier, for: indexPath) as? HumanCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if humanList[indexPath.row].isSick {
            cell.backgroundColor = .red
            
        } else {
            cell.backgroundColor = .green
        }
        return cell
    }
    
    
}
