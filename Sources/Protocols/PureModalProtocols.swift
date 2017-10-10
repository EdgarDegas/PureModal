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
