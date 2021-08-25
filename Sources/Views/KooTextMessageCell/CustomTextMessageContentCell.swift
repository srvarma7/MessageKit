//
//  CustomTextMessageContentCell.swift
//  KooVoice
//
//  Created by Sai Kallepalli on 23/7/21.
//  Copyright © 2021 Bombinate Technologies Pvt Ltd. All rights reserved.
//

import UIKit
import MessageKit

class CustomTextMessageContentCell: CustomMessageContentCell {
    
    /// The label used to display the message's text.
    var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = KooFont.messageText
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.messageLabel.attributedText = nil
        self.messageLabel.text = nil
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        self.messageContainerView.addSubview(self.messageLabel)
    }
    
    override func configure(with message: MessageType,
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
/*

class CustomTextMessageCell: MessageContentCell {

    /// The top label of the cell.
    var cellTopTimeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var cellBottomDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.setupSubviews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.cellTopTimeLabel.text = nil
        self.cellTopTimeLabel.attributedText = nil
        
        self.cellBottomDateLabel.text = nil
        self.cellBottomDateLabel.attributedText = nil
    }
    
    override func setupSubviews() {
        
        contentView.addSubview(messageContainerView)
        
        messageContainerView.layer.cornerRadius = 20
        messageContainerView.backgroundColor = .red
        
        self.contentView.addSubview(self.cellTopLabel)
        self.contentView.addSubview(self.messageContainerView)
//        self.messageContainerView.addSubview(self.cellDateLabel)
    }
    
    override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        
        guard let dataSource = messagesCollectionView.messagesDataSource else {
            print("messagesCollectionView.messagesDataSource not found")
            return
        }
        
        if dataSource.isFromCurrentSender(message: message) {
            messageContainerView.layer.maskedCorners = [
                .layerMaxXMinYCorner, // Top right
                .layerMinXMinYCorner, // Top left
                .layerMinXMaxYCorner  // Bottom left
            ]
        } else {
            messageContainerView.layer.maskedCorners = [
                .layerMaxXMinYCorner, // Top right
                .layerMinXMinYCorner, // Top left
                .layerMaxXMaxYCorner  // Bottom right
            ]
        }
        
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            return
        }
        
        let textMessageKind = message.kind
        switch textMessageKind {
        case .text(let text), .emoji(let text):
            let textColor = displayDelegate.textColor(for: message, at: indexPath, in: messagesCollectionView)
            messageTopLabel.text = text
            messageTopLabel.textColor = textColor
        case .attributedText(let text):
            messageTopLabel.attributedText = text
        default:
            break
        }
    }
}
*/
