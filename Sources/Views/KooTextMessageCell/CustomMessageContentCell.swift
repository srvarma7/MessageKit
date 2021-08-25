//
//  CustomMessageContentCell.swift
//  KooVoice
//
//  Created by Sai Kallepalli on 23/7/21.
//  Copyright © 2021 Bombinate Technologies Pvt Ltd. All rights reserved.
//

import UIKit

open class CustomMessageContentCell: MessageCollectionViewCell {
    
    /// The `MessageCellDelegate` for the cell.
    open weak var delegate: MessageCellDelegate?
    
    /// The container used for styling and holding the message's content view.
    open var messageContainerView: UIView = {
        let containerView = UIView()
        containerView.clipsToBounds = true
        containerView.layer.masksToBounds = true
        return containerView
    }()

    /// The top label of the cell.
    open var cellTopLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    open var cellDateLabel: UILabel = {
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

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.setupSubviews()
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        self.cellTopLabel.text = nil
        self.cellTopLabel.attributedText = nil
        self.cellDateLabel.text = nil
        self.cellDateLabel.attributedText = nil
    }
    
    /// Handle tap gesture on contentView and its subviews.
    open override func handleTapGesture(_ gesture: UIGestureRecognizer) {
        let touchLocation = gesture.location(in: self)

        switch true {
        case self.messageContainerView.frame.contains(touchLocation) && !self.cellContentView(canHandle: convert(touchLocation, to: messageContainerView)):
            self.delegate?.didTapMessage(in: self)
        case self.cellTopLabel.frame.contains(touchLocation):
            self.delegate?.didTapCellTopLabel(in: self)
        case self.cellDateLabel.frame.contains(touchLocation):
            self.delegate?.didTapMessageBottomLabel(in: self)
        default:
            self.delegate?.didTapBackground(in: self)
        }
    }

    /// Handle long press gesture, return true when gestureRecognizer's touch point in `messageContainerView`'s frame
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let touchPoint = gestureRecognizer.location(in: self)
        guard gestureRecognizer.isKind(of: UILongPressGestureRecognizer.self) else { return false }
        return self.messageContainerView.frame.contains(touchPoint)
    }
    
    open func setupSubviews() {
        
        messageContainerView.layer.cornerRadius = 20
        
        self.contentView.addSubview(self.cellTopLabel)
        self.contentView.addSubview(self.messageContainerView)
        self.messageContainerView.addSubview(self.cellDateLabel)
    }
    
    open func configure(with message: MessageType,
                   at indexPath: IndexPath,
                   in messagesCollectionView: MessagesCollectionView,
                   dataSource: MessagesDataSource,
                   calculator sizeCalculator: CustomLayoutSizeCalculator) {
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
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
        
        self.cellTopLabel.frame = sizeCalculator.cellTopLabelFrame(for: message, at: indexPath)
        
        self.cellDateLabel.frame = sizeCalculator.cellMessageBottomLabelFrame(for: message, at: indexPath)
        
        self.messageContainerView.frame = sizeCalculator.messageContainerFrame(for: message, at: indexPath,
                                                                               fromCurrentSender: dataSource.isFromCurrentSender(message: message))
        self.cellTopLabel.attributedText = dataSource.cellTopLabelAttributedText(for: message,
                                                                                 at: indexPath)
        self.cellDateLabel.attributedText = dataSource.messageBottomLabelAttributedText(for: message,
                                                                                        at: indexPath)
        self.messageContainerView.backgroundColor = displayDelegate.backgroundColor(for: message,
                                                                                    at: indexPath,
                                                                                    in: messagesCollectionView)
        
    }

    /// Handle `ContentView`'s tap gesture, return false when `ContentView` doesn't needs to handle gesture
    open func cellContentView(canHandle touchPoint: CGPoint) -> Bool {
        false
    }
}
