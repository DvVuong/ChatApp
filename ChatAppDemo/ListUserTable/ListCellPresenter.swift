//
//  ListCellPresenter.swift
//  ChatAppDemo
//
//  Created by BeeTech on 09/12/2022.
//

import UIKit
final class ListCellPresenter {
    init() {}
    
    func setHigligh(_ search: String, _ text: String ) -> NSAttributedString {
        let range = (text.lowercased() as NSString).range(of: search.lowercased())
        let mutableAttributedString = NSMutableAttributedString.init(string: text)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: range)
        return mutableAttributedString
    }
}
