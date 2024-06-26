//
//  OnboardingViewModel.swift
//  UniTurkey
//
//  Created by Ali Çolak on 21.04.2024.
//

import PaperOnboarding
import UIKit


final class OnboardingViewModel {
    
    // MARK: - Dependency Properties
    
    weak var delegate: OnboardingViewProtocol?
    private let router: OnboardingRouterProtocol
    
    // MARK: - Properties
    
    private var items = Array<OnboardingItemInfo>()
    
    // MARK: - Init
    
    init(router: OnboardingRouterProtocol) {
        self.router = router
        setupItems()
    }
    
    // MARK: - Methods
    
    private func setupItems() {
        let titles = Constants.Onboarding.titles
        let descriptions = Constants.Onboarding.descriptions
        let icons = Constants.Onboarding.icons
        let backgroundColors = Constants.Onboarding.backgroundColors
        let titleColor = Constants.Onboarding.titleColor
        let descriptionColor = Constants.Onboarding.descriptionColor
        let titleFont = Constants.Onboarding.titleFont
        let descriptionFont = Constants.Onboarding.descriptionFont
        
        for index in 0..<titles.count {
            let title = titles[safe: index] ?? ""
            let description = descriptions[safe: index] ?? ""
            let icon = icons[safe: index] ?? UIImage()
            let backgroundColor = backgroundColors[safe: index] ?? .white
            let item = OnboardingItemInfo(informationImage: icon ?? UIImage(),
                                          title: title,
                                          description: description,
                                          pageIcon: icon ?? UIImage(),
                                          color: backgroundColor ?? .white,
                                          titleColor: titleColor,
                                          descriptionColor: descriptionColor,
                                          titleFont: titleFont,
                                          descriptionFont: descriptionFont)
            
            items.append(item)
        }
    }
    
    private func item(at index: Int) -> OnboardingItemInfo{
        guard let item = items[safe: index] else {
            return OnboardingItemInfo(informationImage: UIImage(),
                                      title: "",
                                      description: "",
                                      pageIcon: UIImage(),
                                      color: .white,
                                      titleColor: .black,
                                      descriptionColor: .black,
                                      titleFont: .systemFont(ofSize: 24, weight: .semibold),
                                      descriptionFont: .systemFont(ofSize: 18, weight: .regular))
        }
        return item
    }
    
    
    private func navigate(to route: OnboardingRoute) {
        app.stroageService.setOnBoardingSeen()
        router.navigate(to: route)
    }
    
}

// MARK: - Onboarding ViewModel Delegate

extension OnboardingViewModel: OnboardingViewModelProtocol {
    
    func viewDidLoad() {
        delegate?.prepareOnboarding()
        delegate?.prepareUI()
    }
    
    func viewDidLayoutSubviews() {
        delegate?.prepareConstraints()
    }
    
    func didSkipButtonTapped() {
        navigate(to: .home)
    }
    
    func numberOfPages() -> Int {
        items.count
    }
    
    func onboardingWillTransitonToIndex(at index: Int) {
        if index == items.count - 1 {
            delegate?.showSkipButton()
        } else {
            delegate?.hideSkipButton()
        }
    }
    
    func pageForItem(at index: Int) -> OnboardingItemInfo {
        item(at: index)
    }
    
}
