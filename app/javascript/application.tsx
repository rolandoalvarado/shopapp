// app/javascript/application.tsx
import React from "react"
import ReactDOM from "react-dom/client"
import App from "./App"

const rootElement = document.getElementById("root")
if (rootElement) {
  const root = ReactDOM.createRoot(rootElement)
  root.render(<App />)
}
else {
  console.error("Root element not found")
}
// This file is the entry point for the React application.
// It initializes the React application by rendering the App component into the root element.
// Ensure that the root element exists in your HTML layout file (e.g., app/views/layouts/application.haml).
// If the root element is not found, an error will be logged to the console.
// This setup is necessary for integrating React with Rails, especially when using the react-rails gem.
// Make sure to include this file in your application's JavaScript pack or import it in your main JavaScript file.