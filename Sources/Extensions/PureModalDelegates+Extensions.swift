//
//  PureModalDelegates+Extensions.swift
//  PureModal
//
//  Created by 孙一萌 on 2017/10/10.
//  Copyright © 2017年 iMoeNya. All rights reserved.
//

import Foundation

public extension PureModalControllerDelegate {
    func modalController(_ controller: PureModalController, didTapOuterAreaOfModalView modalView: PureModalView) { }
    func modalController(_ controller: PureModalController, didTapNonButtonArea area: UIView?, ofModalView modalView: PureModalView) { }
}

public extension PureCardControllerDelegate {
    func cardController(_ controller: PureCardController, didTapCancelButtonOfCardView cardView: PureCardView) { }
}
