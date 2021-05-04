using { sap.capire.bookshop as my } from '../db/schema';

@path:'/orders'
service OrdersService {
  entity Orders as projection on my.Orders;
  entity Books as projection on my.Books;
}