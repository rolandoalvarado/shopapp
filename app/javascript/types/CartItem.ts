
import { Product } from './Product';

export type CartItem = {
  id: number;
  product: Product;
  quantity: number;
  adjusted_price: number;
  total_price: number;
};