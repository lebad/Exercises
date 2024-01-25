//
//  NavStackHolder.swift
//  Exercises
//
//  Created by Andrey Lebedev on 23.01.2024.
//

import SwiftUI

public class NavStackHolder {
  public weak var viewController: UIViewController?
  
  public init() {}
}

public protocol ViewControllable: View {
  var holder: NavStackHolder { get set }
  
  func loadView()
  func viewOnAppear(viewController: UIViewController)
}

public extension ViewControllable {
  var viewController: UIViewController {
	let viewController = NavStackHostingController(rootView: self)
	self.holder.viewController = viewController
	return viewController
  }
  
  func loadView() {}
  func viewOnAppear(viewController: UIViewController) {}
}

public class NavStackHostingController<ContentView>: UIHostingController<ContentView> where ContentView: ViewControllable {
  public override func loadView() {
	super.loadView()
	self.rootView.loadView()
  }
  
  public override func viewWillAppear(_ animated: Bool) {
	super.viewWillAppear(animated)
	self.rootView.viewOnAppear(viewController: self)
  }
}
