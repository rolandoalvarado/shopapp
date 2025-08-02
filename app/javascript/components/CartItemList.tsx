import React from "react";

import RemoveCartItemButton from "./RemoveCartItemButton";

type Product = {
  id: number;
  name: string;
  price: number;
};

type CartItem = {
  id: number;
  quantity: number;
  product: Product;
};

type CartItemListProps = {
  cartItems: CartItem[];
  onRemove: (id: number) => void;
};

const CartItemList: React.FC<CartItemListProps> = ({ cartItems, onRemove }) => {
  if (!cartItems || cartItems.length === 0) {
    return <div className="mt-6 text-gray-600">Cart is empty.</div>;
  }

  return (
    <div className="mt-6">
      <h2 className="text-xl font-semibold mb-2">Cart Items</h2>
      <ul className="space-y-2">
        {cartItems.map((item) => (
          <li
            key={item.id}
            className="flex justify-between items-center border p-3 rounded-md bg-gray-50"
          >
            <span className="font-medium">{item.product.name}</span>
            <span className="text-sm text-gray-600 ml-2">
              Qty: {item.quantity}
            </span>
            <span>
              <RemoveCartItemButton cartItemId={item.id} onRemove={() => onRemove(item.id)} />
            </span>
          </li>
        ))}
      </ul>
    </div>
  );
};

export default CartItemList;
