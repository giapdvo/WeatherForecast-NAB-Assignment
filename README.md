# Weather Forecast

## Table Of Content

- [Problem Statement](#problem-statement)
- [Architecture](#architecture)
- [Project Structure](#upgrade-modules)
- [Guidelines](#guidelines)

## Problem Statement

Below are the features that the weather forecast application supported.

- [x] The application is a simple iOS application which is written by Swift.
- [x] The application is able to retrieve the weather information from OpenWeatherMaps API.
- [x] The application is able to allow user to input the searching term.
- [x] The application is able to proceed searching with a condition of the search term length must be from 3 characters or above.
- [x] The application is able to render the searched results as a list of weather items.
- [x] The application is able to support caching mechanism so as to prevent the app from generating a bunch of API requests.
- [x] The application is able to manage caching mechanism & lifecycle.
- [x] The application is able to load the weather icons remotely and displayed one very weather item at the right-hand-side.
- [x] The application is able to handle failures.
- [x] The application is able to support the disability to scale large text for who can't see the text clearly.
- [x] The application is able to support the disability to read out the text using VoiceOver controls.

## Architecture

**This project will not use any 3rd library, just building the project base on the architecture theory and the functioning that apple provides.**

- Clean Architecture + MVVM
- Data Binding using Observable without 3rd party libraries
- Dependency Injection
- Flow Coordinator
- Data caching (Using CoreDate)
- Error Handling

## High-Level Design

### Layer

- **Domain Layer** = Entities + Use Cases + Repositories Interfaces
- **Data Repositories Layer** = Repositories Implementations + API (Network) + Persistence DB
- **Presentation Layer** (MVVM) = ViewModels + Views

### Dependency Direction

![Alt text](README_FILES/CleanArchitectureDependencies.png?raw=true 'Modules Dependencies')

## Low-level Design

### Data Flow

![Alt text](README_FILES/Dataflow.png?raw=true 'Data Flow Between Components')

1. View(UI) calls method from ViewModel(Presenter)
2. ViewModel executes Use Case(Domain)
3. Use Case combines data from User and Repositories.
4. Each Repository returns data from a Remote Data (Network), Persistent DB Storage Source or In-memory Data (Remote or Cached). For the Forecast Weather application it will apply cache for 2 kinds of data

   - **Queries**: The query that user input on the search bar. The maximum cache depend on we set in the **WeatherForecastSceneDIContainer**.
   - **Forecast Result**: The Forecast result from the API. The cache only valid with a day. If the day move to next day the application will make a request to the Server to get the news forecast in the first request.

5. Information flows back to the View(UI) where we display the list of items.

## Project Structure

```markdown
weatherforecast/
|- weatherforecast
|- Application
|- Presentation
|- Domain
|- Data
|- Network
|- Common
|- Resouces
|- weatherforecastTests
|- weatherforecastUITests
```

- `Application`: The application controller and initialize
- `Presentation`: The layer that interacts with the UI.
- `Domain`: Contains the business logic of the app.
- `Data`: Abstract definition of all the data sources.
- `Network`: Handle the network call.
- `Common`: Some common code for reuse on different places
- `Resources`: All of resouces that using in the app exp: Localization, Assets, Audio files etc...

## Demo
