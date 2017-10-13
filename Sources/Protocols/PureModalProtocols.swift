//
//  PureModalProtocols.swift
//  PureModal
//
//  Created by 孙一萌 on 2017/10/10.
//  Copyright © 2017年 iMoeNya. All rights reserved.
//

import UIKit

public protocol PureModalControllerDelegate: class {
    func modalController(_ controller: PureModalController, didTapOuterAreaOfModalView modalView: PureModalView)
    func modalController(_ controller: PureModalController, didTapNonButtonArea area: UIView?, ofModalView modalView: PureModalView)
}

public protocol PureModalViewDelegate: class {
    func modalView(_ modalView: PureModalView, didTapNonButtonArea area: UIView?)
}

public protocol PureCardControllerDelegate: PureModalControllerDelegate {
    func cardController(_ controller: PureCardController, didTapCancelButtonOfCardView cardView: PureCardView)
}

public protocol PureCardViewDelegate: PureModalViewDelegate {
    func didTapCancelButton(ofCardView cardView: PureCardView)
}

public protocol PureModal: class {
    associatedtype InnerView: PureModalView
    var tintColor: UIColor? { get set }
    var window: UIWindow! { get }
    var modalPresentingHelper: PureModalPresentingHelper { get }
    var modalTitle: String? { get set }
    var modalMessage: String? { get set }
    var innerView: InnerView! { get set }
}
