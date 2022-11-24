//
//  SquareViewController.swift
//  Square
//
//  Created by huse on 23/11/22.
//

import UIKit

class SquareView : UIView {
    
    var padding = CGFloat (8)
    var squareHeight = CGFloat (24)
    var preferredMaxLayoutWidth = CGFloat(10_000)
    
    var squares = Int(1) {
        didSet {
            preferredMaxLayoutWidth = CGFloat(10_000)
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        
        let width = squareHeight * CGFloat(squares) + padding * CGFloat(squares) + padding
        
        if width < preferredMaxLayoutWidth {
            let height = squareHeight + padding + padding
            let size = CGSize(width: width, height: height)
            debugPrint("intrinsic content size  \(size)")
            return size
        }
        else {
            let vertSquares = ceil((width / preferredMaxLayoutWidth))
            let height = squareHeight * vertSquares + padding * vertSquares + padding
            let size = CGSize(width: preferredMaxLayoutWidth, height: height)
            debugPrint("intrinsic content size  \(size)")
            return size
        }
    }
    
    override func layoutSubviews() {
        //https://www.objc.io/issues/3-views/advanced-auto-layout-toolbox/
        //Intrinsic Content Size of Multi-Line Text
        super.layoutSubviews()
        preferredMaxLayoutWidth = self.frame.size.width
        
        invalidateIntrinsicContentSize()
        setNeedsDisplay()
        super.layoutSubviews()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.scaleBy(x: 1.0, y: 1.0)
        
        context.setStrokeColor(UIColor.red.cgColor)
        
        var rect = CGRect(x: 0, y: 0, width: squareHeight, height: squareHeight)
        rect.origin.x = padding
        rect.origin.y = padding
        
        for _ in 0 ..< squares {
            
            context.addRect(rect)
            rect.origin.x += squareHeight
            rect.origin.x += padding
            
            if rect.origin.x + squareHeight + padding > bounds.size.width {
                rect.origin.x = padding
                rect.origin.y += squareHeight
                rect.origin.y += padding
            }
        }
        
        context.strokePath()
        
        context.setStrokeColor(UIColor.blue.cgColor)
        context.addRect(bounds.insetBy(dx: 0, dy: 0))
        context.strokePath()
        
    }
}


class SquareCell: UITableViewCell {

    lazy var squareView : SquareView = {
        let view = SquareView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layoutViews()
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
            //force layout of all subviews including self, which
            //updates self's intrinsic height, and thus height of a cell
            self.setNeedsLayout()
            self.layoutIfNeeded()

            //now intrinsic height is correct, call super method
            return super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
    }
    
    func layoutViews() {
        contentView.addSubview(squareView)
        NSLayoutConstraint.activate([
            squareView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            squareView.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -20),
            squareView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            squareView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
        ])
    }
}


class SquareViewController: UIViewController {
    
    var myTableView : UITableView = UITableView()
    var data = [4,7,26,21,14,11,13,2,17,15,29,27,10,10,7,17,28,13,2,14 ]
    
    private var windowInterfaceOrientation: UIInterfaceOrientation? {
            return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
    }
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) in
            guard let windowInterfaceOrientation = self.windowInterfaceOrientation else { return }
            
            if windowInterfaceOrientation.isLandscape {
                self.myTableView.reloadData()
            } else {
                //self.myTableView.reloadData()
            }
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        navigationItem.title = "Squares"
        
        myTableView.register(SquareCell.self, forCellReuseIdentifier: "id")
         
        myTableView.delegate = self
        myTableView.dataSource = self
        
        view.addSubview(myTableView)
        myTableView.frame = view.frame
//        table.separatorStyle = .none
        myTableView.allowsSelection = false
        
        myTableView.estimatedRowHeight = 80
        myTableView.rowHeight = UITableView.automaticDimension
        
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            myTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            myTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
    }
    
}


extension SquareViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! SquareCell
        
        cell.textLabel?.numberOfLines = 0
        cell.squareView.squares = data[indexPath.row]
        
        return cell
    }
}
