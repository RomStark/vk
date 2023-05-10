//
//  ViewController.swift
//  vk
//
//  Created by Al Stark on 10.05.2023.
//

import UIKit

class ViewController: UIViewController {
    let startButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    let groupSizeLabel: UILabel = {
        let label = UILabel()
        label.text = "groupSize: 1"
        return label
    }()
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "timer: 1"
        return label
    }()
    
    let infectionFactorLabel: UILabel = {
        let label = UILabel()
        label.text = "infectionFactor: 1"
        return label
    }()
    
    let groupSizeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 500
       
        return slider
    }()
    
    let timerSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 5
        
        return slider
    }()
    
    let infectionFactorSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 8
       
        return slider
    }()
    
    let sliderStack: UIStackView = {
        let stack = UIStackView()
        return stack
    }()
    
    let titleStack: UIStackView = {
        let stack = UIStackView()
        return stack
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        setupUI()
    }
}

private extension ViewController {
    
    @objc func groupSizeSliderValueChanged() {
        groupSizeLabel.text = "groupSize: \(Int(groupSizeSlider.value))"
    }
    @objc func timerSliderValueChanged() {
        timerLabel.text = "timer: \(Int(timerSlider.value))"
        
        
    }
    @objc func infectionFactorSliderValueChanged() {
        infectionFactorLabel.text = "infectionFactor: \(Int(infectionFactorSlider.value))"
    }
    
    
    func setupUI() {
        setupTitleStack()
        setupSliderStack()
        setupStartButton()
    }
    func setupTitleStack() {
        view.addSubview(titleStack)
        titleStack.addArrangedSubview(groupSizeLabel)
        titleStack.addArrangedSubview(timerLabel)
        titleStack.addArrangedSubview(infectionFactorLabel)
        titleStack.axis = .vertical
        titleStack.spacing = 30
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        
        titleStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        titleStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        
        titleStack.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
//        sliderStack.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    
    func setupSliderStack() {
        view.addSubview(sliderStack)
        sliderStack.addArrangedSubview(groupSizeSlider)
        sliderStack.addArrangedSubview(timerSlider)
        sliderStack.addArrangedSubview(infectionFactorSlider)
        timerSlider.addTarget(self, action: #selector(timerSliderValueChanged), for: .valueChanged)
        groupSizeSlider.addTarget(self, action: #selector(groupSizeSliderValueChanged), for: .valueChanged)
        infectionFactorSlider.addTarget(self, action: #selector(infectionFactorSliderValueChanged), for: .valueChanged)
        sliderStack.axis = .vertical
        sliderStack.spacing = 20
        
        sliderStack.translatesAutoresizingMaskIntoConstraints = false
        
        sliderStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        sliderStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        sliderStack.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
//        sliderStack.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    
    func setupStartButton() {
        view.addSubview(startButton)
        
        startButton.setTitle("Начать", for: .normal)
        startButton.backgroundColor = .gray
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30.0).isActive = true
        
        startButton.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        
        startButton.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
        
        startButton.addTarget(self, action: #selector(StartButtonTapped), for: .touchUpInside)
    }
    
    @objc func StartButtonTapped() {
        let vc = CollectionViewController()
        vc.configure(count: Int(groupSizeSlider.value), time: Int(timerSlider.value), infectionFactor: Int(infectionFactorSlider.value))
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
