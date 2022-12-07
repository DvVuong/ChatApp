//
//  DetailViewViewController.swift
//  ChatAppDemo
//
//  Created by mr.root on 12/7/22.
//

import UIKit

class DetailViewViewController: UIViewController {
    static func instance() -> DetailViewViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailScreen") as! DetailViewViewController
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    

}
