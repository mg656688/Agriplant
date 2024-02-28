import 'package:agriplant/models/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agriplant/view_model/market/market_view_model.dart';
part 'market_state.dart';

class MarketCubit extends Cubit<MarketState> {
  MarketCubit() : super(MarketInitial());
  double get totalPrice {
    double currentPrice = 0;
    for (var element in MarketViewModel().cart) {
      currentPrice = currentPrice += (element.price);
    }

    return currentPrice;
  }

  //
  void removeFromCart(Product model) {
    MarketViewModel().cart.remove(model);
    emit(MarketRemoveFromCart());
  }

  ///
  void onChangeCouponField() {
      emit(MarketInputCoupon());

  }
}
