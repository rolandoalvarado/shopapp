import React from "react";

type CartItem = {
  id: number;
  quantity: number;
  product: {
    name: string;
  };
};

type CartItemListProps = {
  cartItems: CartItem[];
};

const CartItemList: React.FC<CartItemListProps> = ({ cartItems }) => {
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
            <span>{item.product.name}</span>
            <span className="text-sm text-gray-600">Qty: {item.quantity}</span>
          </li>
        ))}
      </ul>
    </div>
  );
};

export default CartItemList;
