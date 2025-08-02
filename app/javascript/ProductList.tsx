import React, { useEffect, useState } from "react";

interface Product {
  id: number;
  code: string;
  name: string;
  price: number;
}

const ProductList: React.FC = () => {
  const [products, setProducts] = useState<Product[]>([]);

  useEffect(() => {
    fetch("/products.json")
      .then((res) => res.json())
      .then((data: Product[]) => setProducts(data));
  }, []);

  return (
    <div>
      <h2 className="text-xl font-bold mb-4">Products</h2>
      <ul className="grid grid-cols-2 gap-4">
        {products.map((product) => (
          <li key={product.id} className="p-4 border rounded-lg">
            <h3 className="font-semibold">{product.name}</h3>
            <p className="text-gray-600">{product.code}</p>
            <p>${product.price}</p>
            <button className="mt-2 px-4 py-1 bg-blue-500 text-white rounded">
              Add to Cart
            </button>
          </li>
        ))}
      </ul>
    </div>
  );
};

export default ProductList;
