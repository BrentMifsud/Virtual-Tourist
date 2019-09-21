//
//  PhotoAlbumViewController+NSFetchedResultsControllerDelegate.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-09-14.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation
import CoreData

extension PhotoAlbumViewController: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		blockOperations.removeAll(keepingCapacity: false)
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		collectionView!.performBatchUpdates({ () -> Void in
			self.blockOperations.forEach({ (blockOp) in
				blockOp.start()
			})
		}, completion: { (finished) -> Void in
			self.blockOperations.removeAll(keepingCapacity: false)
			self.collectionView.reloadData()
		})
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

		var op: BlockOperation!

		switch type {
		case .insert:
			op = BlockOperation { [unowned self] in self.collectionView!.insertItems(at: [indexPath!]) }
		case.delete:
			op = BlockOperation { [unowned self] in self.collectionView!.deleteItems(at: [indexPath!]) }
		case.update:
			op = BlockOperation { [unowned self] in self.collectionView!.reloadItems(at: [indexPath!]) }
		case.move:
			op = BlockOperation { [unowned self] in	self.collectionView!.moveItem(at: indexPath!, to: newIndexPath!) }
		@unknown default:
			break
		}

		blockOperations.append(op)
	}
}
