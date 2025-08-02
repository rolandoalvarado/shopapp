import React from "react"
import ReactDOM from "react-dom/client"

import ProductList from "./components/ProductList"

const productListElement = document.getElementById("product-list")
if (productListElement) {
  const productListRoot = ReactDOM.createRoot(productListElement)
  productListRoot.render(<ProductList />)
} else {
  console.error("Product list element not found")
}
// This code dynamically imports the ProductList component and renders it into the element with ID "product-list".
// It ensures that the ProductList component is only loaded when the element is present in the DOM.
// If the element is not found, an error is logged to the console.
