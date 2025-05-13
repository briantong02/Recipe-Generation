## FridgeMate – Smarter Cooking Starts in Your Fridge

FridgeMate is a SwiftUI-based iOS app built to support international students and young professionals in managing their refrigerator inventory, minimising food waste, and receiving smart recipe suggestions based on real-time ingredient availability.

Developed with a user-first mindset and powered by the Spoonacular API, the app bridges the gap between available ingredients and everyday cooking needs.

---

### Team Contributions

- **Chaeyeon Yu** – Led data modelling and integration efforts, established the core architectural structure of the app, and maintained code synchronisation across modules.
- **Duy Hai Tong** – Conducted competitor research and supported the integration of Spoonacular API into the app's recipe recommendation system.
- **Jungmin Ahn** – Designed and implemented the MVP, including user interface (UI) and user experience (UX) components. Produced Figma wireframes and optimised the overall application structure.
- **Rujeet Parajapati** – Focused on developing and refining the recipe recommendation model to align with ingredient input and user preferences.

---

## Github Repository Link

[FridgeMate Repository](https://github.com/briantong02/Recipe-Generation)

---

## Project Overview & Solutions

Despite having a fridge full of groceries, many users still struggle with the question:  
“What can I cook with what I already have?”

FridgeMate solves this challenge by:

- Tracking ingredients in the fridge with expiry-aware data.
- Recommending personalised recipes using a real-time ingredient-matching engine.
- Supporting cooking decisions based on time, skill level, and dietary preferences.
- Reducing food waste and unnecessary grocery spending.

---

## Target Audience

FridgeMate was designed with a primary focus on:

- International students living in Australia, balancing limited time, budget, and cooking experience.
- Users who frequently forget what they have at home and end up over-purchasing or wasting food.
- Home cooks looking for convenient, personalised, and affordable recipe ideas.

---

## Comparison to Other Competitive Services

FridgeMate was developed in response to key limitations observed in existing recipe and cooking assistant apps:

- **Tasty**: Offers high-quality, video-driven recipes but lacks personalised recommendations based on user ingredients.
- **Cookpad**: Focuses on community-shared recipes, yet suffers from inconsistent quality and lacks ingredient-level personalization.
- **Yummly**: Provides extensive filters (e.g., dietary preferences, equipment), but operates on a search-and-select model, requiring user effort rather than offering proactive suggestions.

FridgeMate differentiates itself by delivering real-time recipe recommendations based on actual fridge contents, enhanced with local filtering to bypass external API constraints. The interface is designed to be lightweight and intuitive, catering specifically to students and time-constrained users without login required.

---
## Tech Stack

| Layer              | Technology                                           |
|--------------------|------------------------------------------------------|
| Language           | Swift                                                |
| UI Framework       | SwiftUI                                              |
| API Provider       | [Spoonacular API](https://spoonacular.com/food-api)  |
| Storage            | Local JSON file persistence                          |
| Version Control    | Git + GitHub                                         |
| Design Tool        | Figma                                                |

---

## Architecture: MVVM (Model-View-ViewModel) design pattern

Modular file organization:

- Models/ – Data structures (e.g., Ingredient, Recipe)
- ViewModels/ – Business logic for views and API handling
- Views/ – SwiftUI UI Components
- Services/ – API interaction layer (e.g., RecipeService.swift)

---

## Core Features

FridgeMate provides an intuitive and efficient cooking assistant experience through the following key features:

- **Ingredient Management**: Users can easily add, update, or remove ingredients stored in their fridge. Each ingredient entry supports categories, units of measurement, and optional expiry dates, enabling smarter kitchen planning.

- **Smart Recipe Recommendations**: Leveraging the Spoonacular API, the app dynamically fetches recipes that match the ingredients users currently have. This real-time matching system reduces food waste and eliminates the stress of last-minute grocery runs.

- **Cooking Time-Based Filtering**: Every recipe suggestion includes cooking time, allowing users to make choices that match their available time.

- **Bookmark Syncing Across Views**: Users can bookmark their favorite recipes for quick access later. These bookmarks are synced across relevant views, such as the Recipe Recommendation list and the Recipe Detail screen. When a user marks a recipe as a favorite in one view, the change is reflected in all other views instantly through shared state management, ensuring a seamless and consistent user experience across browsing and meal planning.

- **Local Data Persistence**: Fridge contents and user preferences are saved locally to ensure that data remains intact between app launches without requiring sign-in or server-side storage.

Together, these features work to simplify the cooking process, reduce food waste, and empower users to make the most of what they already have at home.

---

## Challenges

We initially aimed to implement a tier-based ranking algorithm for recipe relevance. However, due to limited time and complexity in evaluation logic, we simplified the experience to prioritise real-time responsiveness. We plan to revisit advanced filtering and scoring mechanisms in future iterations.


---

### MVP Design Approach

We followed an iterative product design cycle to develop the MVP. Starting with paper wireframes, we moved on to high-fidelity Figma mockups and refined user flows through continuous testing and feedback. The final MVP prioritises clarity, responsiveness, and ease of use, ensuring that the core features—ingredient tracking and recipe recommendations—are delivered with minimal friction.

---

## Installation & Setup

Follow the steps below to run the FridgeMate iOS application locally:

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/FridgeMate.git
   cd FridgeMate
   ```
   
2. **Open the project in Xcode (version 15 or later)**

3. **Insert your Spoonacular API key**
- Visit [spoonacular.com](https://spoonacular.com/food-api) to create an account and get a free API key.  
- Open `RecipeService.swift` and `Constant.swift`, and replace the placeholder with your key.


4. **Run the app**
- Select a simulator or connect a physical iOS device.
- Press ⌘ + R or click the Run button in Xcode.

---

## How to Use

Follow these steps to get started with **FridgeMate**:

1. **Launch the app** – Open FridgeMate on your iOS device.
2. **Select your ingredients** – Tap to add items currently in your fridge.
3. **View recipe suggestions** – Navigate to the **Recipes** tab to explore recommended dishes based on your selected ingredients.
4. **Filter by cooking time** – Use the **Filter** button to refine results by your available cooking time.
5. **Check details & bookmark** – Tap any recipe to view full instructions, ingredients, and nutrition info. You can also **bookmark** your favorites for later use.


---

## License

MIT License

Copyright (c) 2025 FridgeMate

Permission is hereby granted, free of charge, to any person obtaining a copy  
of this software and associated documentation files (the "Software"), to deal  
in the Software without restriction, including without limitation the rights  
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell  
copies of the Software, and to permit persons to whom the Software is  
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all  
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE  
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER  
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  
SOFTWARE.
