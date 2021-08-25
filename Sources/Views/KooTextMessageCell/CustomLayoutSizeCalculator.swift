//
//  CustomLayoutSizeCalculator.swift
//  KooVoice
//
//  Created by Sai Kallepalli on 23/7/21.
//  Copyright © 2021 Bombinate Technologies Pvt Ltd. All rights reserved.
//

import UIKit
import MessageKit

open class CustomLayoutSizeCalculator: CellSizeCalculator {
    
    open var cellTopLabelVerticalPadding: CGFloat           = 32
    open var cellTopLabelHorizontalPadding: CGFloat         = 32
    open var cellMessageContainerHorizontalPadding: CGFloat = 48
    open var cellMessageContainerExtraSpacing: CGFloat      = 16
    open var cellMessageContentVerticalPadding: CGFloat     = 16
    open var cellMessageContentHorizontalPadding: CGFloat   = 16
    open var cellDateLabelHorizontalPadding: CGFloat        = 24
    open var cellDateLabelBottomPadding: CGFloat            = 8
    
    open var messagesLayout: MessagesCollectionViewFlowLayout {
        self.layout as! MessagesCollectionViewFlowLayout
    }
    
    open var messageContainerMaxWidth: CGFloat {
        self.messagesLayout.itemWidth -
            self.cellMessageContainerHorizontalPadding -
            self.cellMessageContainerExtraSpacing
    }
    
    open var messagesDataSource: MessagesDataSource {
        self.messagesLayout.messagesDataSource
    }
    
    public init(layout: MessagesCollectionViewFlowLayout? = nil) {
        super.init()
        
        self.layout = layout
    }
    
    open override func sizeForItem(at indexPath: IndexPath) -> CGSize {
        let dataSource = self.messagesDataSource
        let message = dataSource.messageForItem(at: indexPath,
                                                in: self.messagesLayout.messagesCollectionView)
        let itemHeight = self.cellContentHeight(for: message,
                                                at: indexPath)
        return CGSize(width: self.messagesLayout.itemWidth,
                      height: itemHeight)
    }

    open func cellContentHeight(for message: MessageType,
                           at indexPath: IndexPath) -> CGFloat {
        self.cellTopLabelSize(for: message,
                              at: indexPath).height +
            self.cellMessageBottomLabelSize(for: message,
                                   at: indexPath).height +
            self.messageContainerSize(for: message,
                                      at: indexPath).height
    }
    
    // MARK: - Top cell Label

    open func cellTopLabelSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        guard let attributedText = self.messagesDataSource.cellTopLabelAttributedText(for: message, at: indexPath) else {
            return .zero
        }
        
        let maxWidth = self.messagesLayout.itemWidth - self.cellTopLabelHorizontalPadding
        let size = attributedText.size(consideringWidth: maxWidth)
        let height = size.height + self.cellTopLabelVerticalPadding
        
        return CGSize(width: maxWidth,
                      height: height)
    }
    
    open func cellTopLabelFrame(for message: MessageType, at indexPath: IndexPath) -> CGRect {
        let size = self.cellTopLabelSize(for: message, at: indexPath)
        guard size != .zero else {
            return .zero
        }
        
        let origin = CGPoint(x: self.cellTopLabelHorizontalPadding / 2, y: 0)
        
        
        return CGRect(origin: origin, size: size)
    }
    
    open func cellMessageBottomLabelSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        guard let attributedText = self.messagesDataSource.messageBottomLabelAttributedText(for: message, at: indexPath) else {
            return .zero
        }
        
        let maxWidth = self.messageContainerMaxWidth - self.cellDateLabelHorizontalPadding
        
        return attributedText.size(consideringWidth: maxWidth)
    }
    
    open func cellMessageBottomLabelFrame(for message: MessageType, at indexPath: IndexPath) -> CGRect {
        let messageContainerSize = self.messageContainerSize(for: message, at: indexPath)
        let labelSize = self.cellMessageBottomLabelSize(for: message, at: indexPath)
        
        let x = messageContainerSize.width - labelSize.width - (self.cellDateLabelHorizontalPadding / 2)
        let y = messageContainerSize.height - labelSize.height - self.cellDateLabelBottomPadding
        
        var origin = CGPoint(x: x - 10, y: y)
        
        if !messagesDataSource.isFromCurrentSender(message: message) {
            origin = CGPoint(x: 16, y: y)
        }
        
        return CGRect(origin: origin, size: labelSize)
    }
    
    // MARK: - MessageContainer

    open func messageContainerSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        let labelSize = self.cellMessageBottomLabelSize(for: message, at: indexPath)
        let width = labelSize.width + self.cellMessageContentHorizontalPadding + self.cellDateLabelHorizontalPadding
        let height = labelSize.height + self.cellMessageContentVerticalPadding + self.cellDateLabelBottomPadding
        
        return CGSize(width: width, height: height)
    }
    
    open func messageContainerFrame(for message: MessageType, at indexPath: IndexPath, fromCurrentSender: Bool) -> CGRect {
        let y = self.cellTopLabelSize(for: message, at: indexPath).height
        let size = self.messageContainerSize(for: message, at: indexPath)
        let origin: CGPoint
        
        if fromCurrentSender {
            let x = self.messagesLayout.itemWidth - size.width - (self.cellMessageContainerHorizontalPadding / 2)
            origin = CGPoint(x: x + 20, y: y)
        } else {
            origin = CGPoint(x: (self.cellMessageContainerHorizontalPadding / 2) - 20, y: y)
        }
        
        return CGRect(origin: origin, size: size)
    }
    
}
