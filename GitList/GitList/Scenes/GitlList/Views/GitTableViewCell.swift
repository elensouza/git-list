import UIKit

final class GitTableViewCell: UITableViewCell {
    private var photoImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.layer.borderColor = UIColor.secondaryLabel.cgColor
        view.layer.cornerRadius = Size.defaultHeight / 2
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        return view
    }()

    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()

    private var filesQuantityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()

    private var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        addsConstraints()
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepareForReuse() {
        photoImageView.image = UIImage()
        nameLabel.text = ""
        filesQuantityLabel.text = ""
    }

    func setup(with model: GitCellViewModel) {
        photoImageView.download(from: model.photoURL)
        nameLabel.text = model.name
        filesQuantityLabel.text =  model.fileQuantity
    }

    private func addViews() {
        contentView.addSubview(photoImageView)
        containerStackView.addArrangedSubview(nameLabel)
        containerStackView.addArrangedSubview(filesQuantityLabel)
        contentView.addSubview(containerStackView)
    }

    private func addsConstraints() {
        NSLayoutConstraint.activate([
            photoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                    constant: Spacing.small),
            photoImageView.widthAnchor.constraint(equalToConstant: Size.defaultHeight),
            photoImageView.heightAnchor.constraint(equalToConstant: Size.defaultHeight),

            containerStackView.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor,
                                                        constant: Spacing.regular),
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                    constant: Spacing.small),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                         constant: -Spacing.regular),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                       constant: -Spacing.regular)
        ])
    }
}
