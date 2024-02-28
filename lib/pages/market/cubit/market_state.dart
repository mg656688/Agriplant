part of 'market_cubit.dart';

abstract class MarketState {}

class MarketInitial extends MarketState {}

class MarketAddToCart extends MarketState {}

/// Cart view states  
class MarketRemoveFromCart extends MarketState {}
class MarketProductCounter extends MarketState{}
class MarketInputCoupon extends MarketState {}
