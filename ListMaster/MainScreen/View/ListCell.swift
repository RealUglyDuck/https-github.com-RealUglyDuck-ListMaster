

import UIKit

class ListCell: UITableViewCell {
    
    let listName = StandardUILabel()
    
    let created:StandardUILabel = {
        let label = StandardUILabel()
        label.text = "Default"
        label.textAlignment = .right
        return label
    }()
    
    let separator:UIView = {
        let sep = UIView()
        sep.backgroundColor = MAIN_COLOR.withAlphaComponent(0.8)
        return sep
        
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(object:List){
        self.listName.text = object.name
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd/MM/yyyy")
        if let creationDate = object.created {
            self.created.text = dateFormatter.string(from: creationDate)
        }
    }

    func setupView() {
        self.backgroundColor = .clear
        listName.text = "Default"
        addSubview(listName)
        addSubview(created)
        addSubview(separator)
        
        
        _ = listName.constraintsWithDistanceTo(top: nil, left: leftAnchor, right: created.leftAnchor, bottom: nil, topDistance: 0, leftDistance: 25, rightDistance: 0, bottomDistance: 0)
        listName.centerInTheView(centerX: nil, centerY: centerYAnchor)
        
        _ = created.constraintsWithDistanceTo(top: nil, left: nil, right: rightAnchor, bottom: nil, topDistance: 0, leftDistance: 0, rightDistance: 20, bottomDistance: 0)
        created.centerInTheView(centerX: nil, centerY: centerYAnchor)
        created.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        _ = separator.constraintAnchors(top: nil, left: self.leftAnchor, right: self.rightAnchor, bottom: self.bottomAnchor, topDistance: 0, leftDistance: 25, rightDistance: 25, bottomDistance: 0, height: 0.5, width: nil)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
