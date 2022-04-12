# Shop
Shop is an online ecommerce application where users can purchase items they like. Users can browse categories and search through items if they want.

# Description
Shop is a simple online ecommerce application where users can purchase items they like.
- It uses Firebase Authentication (Email and Password).
- It stores data in Firebase Firestore.
- It stores images in Firebase Storage.
- It uses Stripe to purchase items.
- It uses Algolia to easily search an item you like.

# Set Up
To use this app, you will need to setup a project on Firebase, Algolia and Stripe.

Here are the steps to set up your project on Firebase:
1. Create a new project on [Firebase](https://console.firebase.google.com/), download **GoogleInfo-Service.plist** and add it to your project.
2. In Authentication section, enable Email/Password provider for your project.
3. In Firebase Database and Firebase Storage you might need to edit the rules.

Here are the steps for Algolia:

1. Create an app on [Algolia](https://www.algolia.com).
2. Create an index on Algolia for your project.
3. Go to **Searchable attributes** in **Configuration** section, and add "description" and "name" attributes.
4. Copy your **Algolia App ID**, **Algolia Search-Only API Key**, **ADMIN API Key** and **name of the index** you created.

```swift
struct Constants {
  // removed for brevity
  struct Algolia {
    public static let applicationId = "YOUR ALGOLIA APP ID"
    public static let publicKey = "YOUR ALGOLIA SEARCH-ONLY API KEY"
    public static let adminKey = "YOUR ALGOLIA ADMIN API KEY"
    public static let indexName = "YOUR ALGOLIA INDEX NAME"
  }
}

```

Steps for Stripe:
1. Create a project on [Stripe](https://www.stripe.com).
2. Copy your **Secret Key** and paste it in your backend.
3. Copy your **Publishable Key** and paste it in the [Constants.swift](/Shop/Helpers/Constants.swift) file along with your backend's URL.

```swift
struct Constants {
  // removed for brevity
  struct Stripe {
    static let publishableKey = "YOUR-PUBLISHABLE-KEY"
    static let baseURLString = "YOUR-BASE-URL-STRING"
    static let defaultCurrency = "eur"
    static let defaultDescription = "Purchase from Shop"
  }
}
```

# Screenshots

<img src="/Shop/Screenshots/Image%201%20-%20Categories.png" width="231" height="500" alt="Categories"> <img src="/Shop/Screenshots/Image%202%20-%20Items.png" width="231" height="500" alt="Items"> <img src="/Shop/Screenshots/Image%203%20-%20Item%20Detail.png" width="231" height="500" alt="Item Detail"> 
<img src="/Shop/Screenshots/Image%204%20-%20Search.png" width="231" height="500" alt="Search"> <img src="/Shop/Screenshots/Image%207%20-%20Basket.png" width="231" height="500" alt="Basket"> 
