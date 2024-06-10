//
//  GitTableViewCell.swift
//  GitList
//
//  Created by Elen Souza on 10/06/24.
//

import UIKit

final class GitTableViewCell: UITableViewCell {
    private var photoImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = Radius.large
        return view
    }()

    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private var filesQuantityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        addsConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepareForReuse() {
        nameLabel.text = ""
        photoImageView.image = UIImage()
        filesQuantityLabel.text = ""
    }

    func setup(with model: GitCellViewModel) {
        photoImageView.download(from: model.photoURL)
        nameLabel.text = model.name
        filesQuantityLabel.text = "Quantidade de arquivos: \(model.fileQuantity)"
    }

    private func addViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(photoImageView)
        contentView.addSubview(filesQuantityLabel)
    }

    private func addsConstraints() {
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Spacing.small),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photoImageView.widthAnchor.constraint(equalToConstant: 100),
            photoImageView.heightAnchor.constraint(equalToConstant: 100),

            nameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor,
                                               constant: Spacing.regular),
            nameLabel.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor),

            filesQuantityLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor,
                                               constant: Spacing.regular),
            filesQuantityLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Spacing.small)
        ])
    }
}
