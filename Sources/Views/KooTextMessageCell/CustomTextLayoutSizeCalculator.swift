//
//  CustomTextLayoutSizeCalculator.swift
//  KooVoice
//
//  Created by Sai Kallepalli on 23/7/21.
//  Copyright © 2021 Bombinate Technologies Pvt Ltd. All rights reserved.
//

import UIKit
import MessageKit

class CustomTextLayoutSizeCalculator: CustomLayoutSizeCalculator {

    var messageLabelFont = KooFont.messageText
    var cellMessageContainerRightSpacing: CGFloat = 16

    override func messageContainerSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        let size = super.messageContainerSize(for: message, at: indexPath)
        let labelSize = self.messageLabelSize(for: message, at: indexPath)
        let selfWidth = labelSize.width +
            self.cellMessageContentHorizontalPadding +
            self.cellMessageContainerRightSpacing
        let width = max(selfWidth, size.width)
        let height = size.height + labelSize.height
        
        return CGSize(width: width, height: height)
    }
    
    func messageLabelSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        let attributedText: NSAttributedString

        let textMessageKind = message.kind
        switch textMessageKind {
        case .attributedText(let text):
            attributedText = text
        case .text(let text), .emoji(let text):
            attributedText = NSAttributedString(string: text,
                                                attributes: [
                                                    .font: messageLabelFont ?? UIFont.preferredFont(forTextStyle: .body)
                                                ])
        default:
            fatalError("messageLabelSize received unhandled MessageDataType: \(message.kind)")
        }
        
        let maxWidth = self.messageContainerMaxWidth -
            self.cellMessageContentHorizontalPadding -
            self.cellMessageContainerRightSpacing
        
        return attributedText.size(consideringWidth: maxWidth)
    }
    
    func messageLabelFrame(for message: MessageType,
                           at indexPath: IndexPath) -> CGRect {
        let origin = CGPoint(x: self.cellMessageContentHorizontalPadding / 2 + 7,
                             y: self.cellMessageContentVerticalPadding / 2)
        let size = self.messageLabelSize(for: message, at: indexPath)
        
        return CGRect(origin: origin, size: size)
    }
}

