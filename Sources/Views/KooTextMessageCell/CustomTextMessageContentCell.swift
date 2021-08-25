//
//  CustomTextMessageContentCell.swift
//  KooVoice
//
//  Created by Sai Kallepalli on 23/7/21.
//  Copyright © 2021 Bombinate Technologies Pvt Ltd. All rights reserved.
//

import UIKit

open class CustomTextMessageContentCell: CustomMessageContentCell {
    
    /// The label used to display the message's text.
    open var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        self.messageLabel.attributedText = nil
        self.messageLabel.text = nil
    }
    
    open override func setupSubviews() {
        super.setupSubviews()
        
        self.messageContainerView.addSubview(self.messageLabel)
    }
    
    open override func configure(with message: MessageType,
                            at indexPath: IndexPath,
                            in messagesCollectionView: MessagesCollectionView,
                            dataSource: MessagesDataSource,
                            calculator sizeCalculator: CustomLayoutSizeCalculator) {
        super.configure(with: message,
                        at: indexPath,
                        in: messagesCollectionView,
                        dataSource: dataSource,
                        calculator: sizeCalculator)
        
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            return
        }
        
        let calculator = sizeCalculator as? CustomTextLayoutSizeCalculator
        self.messageLabel.frame = calculator?.messageLabelFrame(for: message,
                                                                at: indexPath) ?? .zero
        
        let textMessageKind = message.kind
        switch textMessageKind {
        case .text(let text), .emoji(let text):
            let textColor = displayDelegate.textColor(for: message, at: indexPath, in: messagesCollectionView)
            messageLabel.text = text
            messageLabel.textColor = textColor
        case .attributedText(let text):
            messageLabel.attributedText = text
        default:
            break
        }
    }
}
