//
//  VoiceMemoListCell.swift
//  VoiceMemo-iOS
//
//  Created by ROC Zhang on 2017/9/23.
//  Copyright © 2017年 Roc Zhang. All rights reserved.
//

import UIKit

class VoiceMemoListCell: UITableViewCell {
    
    // MARK: UI Elements
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .voiceMemoListCellTitleFont
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var playButton = PlayButton()
    
    
    // MARK: Data Elements
    
    var state: PlayButton.State = .tapToPlay {
        didSet {
            playButton.state = state
        }
    }
    
    
    // MARK: Life-cycle Methods
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeUI()
        makeLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        state = .tapToPlay
    }
    
    
    // MARK: Private Methods
    
    private func makeUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(playButton)
        
        selectionStyle = .none
        backgroundColor = .voiceMemoBackgroundColor
        playButton.isUserInteractionEnabled = false
    }
    
    private func makeLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Configs.UI.basicLeading),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            playButton.widthAnchor.constraint(equalToConstant: 35),
            playButton.heightAnchor.constraint(equalToConstant: 35),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Configs.UI.basicLeading)
            ])
    }
    
    
    // MARK: Config Methods
    
    func configCell(with memo: VoiceMemo) {
        titleLabel.text = memo.name
    }

}
