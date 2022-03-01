//
//  MapAnnotationView.swift
//  Flanear
//
//  Created by Mattia Fochesato on 28/02/22.
//

import MapKit

class MapAnnotationView: MKAnnotationView {

    @IBOutlet var containerView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    // ... Other outlets
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    
    func setup() {
        
        guard let nibView = loadViewFromNib() else {
            return
        }
        
        contentView = nibView

        bounds = nibView.frame
        addSubview(nibView)
        
        contentView?.translatesAutoresizingMaskIntoConstraints = false
        containerView?.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        containerView?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        
    }
    
    func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let name =  "MapAnnotationView"
        let nib = UINib(nibName: name, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bounds = containerView!.bounds
    }
    override func prepareForReuse() {
        super.layoutSubviews()
        bounds = containerView!.bounds
        
    }

}
