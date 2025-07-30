import XCTest

public class PageObject {
    let app = XCUIApplication()
    
    // Tab bar items
    lazy var catalogButton = app.buttons["Catalog-tab-item"]
    lazy var cartButton = app.buttons["Cart-tab-item"]
    lazy var moreButton = app.buttons["More-tab-item"]
    
    // Menu items
    lazy var webviewButton = app.buttons["Webview-menu-item"]
    lazy var qrCodeScannerButton = app.buttons["QrCodeScanner-menu-item"]
    lazy var geoLocationButton = app.buttons["GeoLocation-menu-item"]
    lazy var drawingButton = app.buttons["Drawing-menu-item"]
    lazy var aboutButton = app.buttons["About-menu-item"]
    lazy var resetAppStateButton = app.buttons["ResetAppState-menu-item"]
    lazy var biometricsButton = app.buttons["Biometrics-menu-item"]
    lazy var logOutButton = app.buttons["LogOut-menu-item"]
    
    // Screens
    lazy var webviewScreen = app.otherElements["Webview-screen"]
    lazy var qrCodeScannerScreen = app.otherElements["QrCodeScanner-screen"]
    lazy var geoLocaltionScreen = app.otherElements["GeoLocation-screen"]
    lazy var drawingScreen = app.otherElements["Drawing-screen"]
    lazy var aboutScreen = app.otherElements["About-screen"]
    lazy var resetAppScreen = app.otherElements["ResetAppState-screen"]
    lazy var biometricsScreen = app.otherElements["Biometrics-screen"]
    lazy var logOutScreen = app.otherElements["LogOut-screen"]
    
    
    // Cart
    lazy var cartScreen = app.otherElements["Cart-screen"]
    lazy var cartEmpty = cartScreen.staticTexts["No Items"]
    lazy var goShoppingButton = cartScreen.buttons["GoShopping"]
    func cartDetailsPageOf(productName: String)-> XCUIElement {
        return cartScreen.staticTexts[productName]
    }

    // Catalog
    lazy var catalogScreen = app.otherElements["Catalog-screen"]
    func selectItemByNumber(itemNumber: Int) -> XCUIElement {
        return app.otherElements.matching(identifier: "ProductItem").element(boundBy: itemNumber)
    }
    func selectItemByName(itemName: String) -> XCUIElement {
        return app.staticTexts[itemName]
    }
    
    // Product Details
    lazy var productDetailsScreen = app.otherElements["ProductDetails-screen"]
    lazy var addToCartButton = productDetailsScreen.buttons["Add To Cart"]
    lazy var infoTitle = productDetailsScreen.staticTexts["Product Highlights"]
    lazy var substractAmountButton = productDetailsScreen.buttons["SubtractMinus Icons"]
    lazy var addAmountButton = productDetailsScreen.buttons["AddPlus Icons"]
    lazy var rateValue = productDetailsScreen.buttons["StarSelected Icons"]
    lazy var averageRateButton = productDetailsScreen.children(matching: .other).element(boundBy: 1)
    func productAmount(amount: String)-> XCUIElement {
        return productDetailsScreen.staticTexts[amount]
    }
    func detailsPageOf(productName: String)-> XCUIElement {
        return productDetailsScreen.staticTexts[productName]
    }
    func getPrice (price: String) -> XCUIElement {
        return productDetailsScreen.staticTexts[price]
    }
    func getColor (color: String) -> XCUIElement {
        return productDetailsScreen.buttons[color + "ColorUnSelected Icons"]
    }
    
    // Checkout Flow Elements
    
    // Cart Screen
    lazy var proceedToCheckoutButton = cartScreen.buttons["Proceed To Checkout"]
    lazy var cartItemCountLabel = cartScreen.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Items'")).firstMatch
    lazy var cartTotalPriceLabel = cartScreen.staticTexts.matching(NSPredicate(format: "label CONTAINS '$'")).firstMatch
    lazy var deleteProductButton = cartScreen.buttons["Delete Icons"]
    lazy var addQuantityButton = cartScreen.buttons["AddPlus Icons"]
    lazy var subtractQuantityButton = cartScreen.buttons["SubtractMinus Icons"]
    
    // Shipping Address Screen
    lazy var shippingScreen = app.otherElements["ShippingAddress-screen"]
    lazy var fullNameTextField = shippingScreen.textFields["Full Name"]
    lazy var address1TextField = shippingScreen.textFields["Address Line 1"]
    lazy var address2TextField = shippingScreen.textFields["Address Line 2"]
    lazy var cityTextField = shippingScreen.textFields["City"]
    lazy var stateTextField = shippingScreen.textFields["State/Region"]
    lazy var zipCodeTextField = shippingScreen.textFields["Zip Code"]
    lazy var countryTextField = shippingScreen.textFields["Country"]
    lazy var toPaymentButton = shippingScreen.buttons["To Payment"]
    lazy var shippingBackButton = shippingScreen.buttons["BackButton Icons"]
    
    // Payment Method Screen
    lazy var paymentScreen = app.otherElements["PaymentMethod-screen"]
    lazy var cardHolderNameTextField = paymentScreen.textFields["Full Name"]
    lazy var cardNumberTextField = paymentScreen.textFields["Card Number"]
    lazy var expirationDateTextField = paymentScreen.textFields["Expiration Date"]
    lazy var securityCodeTextField = paymentScreen.textFields["Security Code"]
    lazy var billingAddressToggle = paymentScreen.buttons["Billing Address"]
    lazy var reviewOrderButton = paymentScreen.buttons["Review Order"]
    lazy var paymentBackButton = paymentScreen.buttons["BackButton Icons"]
    lazy var securityCodeTipButton = paymentScreen.buttons["SecurityCodeTip"]
    
    // Billing Address Fields (when toggle is enabled)
    lazy var billingFullNameTextField = paymentScreen.textFields["Billing Full Name"]
    lazy var billingAddress1TextField = paymentScreen.textFields["Billing Address Line 1"]
    lazy var billingAddress2TextField = paymentScreen.textFields["Billing Address Line 2"]
    lazy var billingCityTextField = paymentScreen.textFields["Billing City"]
    lazy var billingStateTextField = paymentScreen.textFields["Billing State/Region"]
    lazy var billingZipCodeTextField = paymentScreen.textFields["Billing Zip Code"]
    lazy var billingCountryTextField = paymentScreen.textFields["Billing Country"]
    
    // Review Order Screen
    lazy var reviewScreen = app.otherElements["ReviewOrder-screen"]
    lazy var placeOrderButton = reviewScreen.buttons["Place Order"]
    lazy var reviewBackButton = reviewScreen.buttons["BackButton Icons"]
    lazy var orderSummaryTable = reviewScreen.tables["OrderSummary"]
    lazy var shippingInfoSection = reviewScreen.staticTexts["Shipping Information"]
    lazy var paymentInfoSection = reviewScreen.staticTexts["Payment Information"]
    lazy var orderTotalLabel = reviewScreen.staticTexts.matching(NSPredicate(format: "label CONTAINS '$'")).firstMatch
    
    // Checkout Complete Screen
    lazy var checkoutCompleteScreen = app.otherElements["CheckoutComplete-screen"]
    lazy var continueShoppingButton = checkoutCompleteScreen.buttons["Continue Shopping"]
    lazy var orderConfirmationMessage = checkoutCompleteScreen.staticTexts["Checkout Complete"]
    
    // Authentication Screen (if login is required)
    lazy var loginScreen = app.otherElements["Login-screen"]
    lazy var usernameTextField = loginScreen.textFields["username"]
    lazy var passwordTextField = loginScreen.secureTextFields["password"]
    lazy var loginButton = loginScreen.buttons["Login"]
    
    // Alert Elements
    lazy var validationErrorAlert = app.alerts["Validation Error!"]
    lazy var alertOKButton = app.alerts.buttons["OK"]
    
    // Helper functions for checkout
    func getCartProductByName(_ productName: String) -> XCUIElement {
        return cartScreen.staticTexts[productName]
    }
    
    func getCartProductQuantity(_ quantity: String) -> XCUIElement {
        return cartScreen.staticTexts[quantity]
    }
    
    func getOrderTotalWithShipping(_ amount: String) -> XCUIElement {
        return reviewScreen.staticTexts[amount]
    }
    
    func getProductInReview(_ productName: String) -> XCUIElement {
        return reviewScreen.staticTexts[productName]
    }
    
    func waitForScreen(_ screenName: String, timeout: TimeInterval = 10) {
        let screen = app.otherElements[screenName + "-screen"]
        let exists = screen.waitForExistence(timeout: timeout)
        XCTAssertTrue(exists, "Screen \(screenName) should appear within \(timeout) seconds")
    }
    
    // Enhanced selectors for better reliability
    func findElementByText(_ text: String) -> XCUIElement {
        return app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] %@", text)).firstMatch
    }
    
    func findButtonByText(_ text: String) -> XCUIElement {
        return app.buttons.containing(NSPredicate(format: "label CONTAINS[c] %@", text)).firstMatch
    }
    
    func findTextFieldByPlaceholder(_ placeholder: String) -> XCUIElement {
        return app.textFields.containing(NSPredicate(format: "placeholderValue CONTAINS[c] %@", placeholder)).firstMatch
    }
}
