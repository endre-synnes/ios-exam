//
//  RecommendedView.swift
//  Swars


protocol UpdateRecommendationView {
    func update(headerTxt: String, descriptionText: String)
}

import UIKit

class RecommendedView: UIView, UpdateRecommendationView {
    
    private var headerLbl: UILabel!
    private var descriptionLbl: UILabel!
    private var image: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.createAddSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(headerTxt: String, descriptionText: String) {
        headerLbl.text = headerTxt
        descriptionLbl.text = descriptionText
    }
    
    private func createAddSubviews() {
        setupViews()
        self.addSubview(image)
        self.addSubview(headerLbl)
        self.addSubview(descriptionLbl)
    }
    
    private func setupViews() {
        characterImage()
        addHeaderLbl()
        description()
    }
    
    private func addHeaderLbl() {
        headerLbl = UILabel.init(frame: CGRect.init(x: image.frame.width + 8, y: 0, width: UIScreen.main.bounds.width - image.frame.width + 8, height: 30))
        headerLbl.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    private func description() {
        descriptionLbl = UILabel.init(frame: CGRect.init(x: image.frame.width + 8, y: headerLbl.bounds.height, width: UIScreen.main.bounds.width - image.frame.width + 8, height: 30))
    }
    
    private func characterImage() {
        image = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 60))
        //Fill for 'zoome' effect.
        image.contentMode = .scaleAspectFit
        image.image = UIImage.init(named: "bobafat")
    }
    
    
    
}
