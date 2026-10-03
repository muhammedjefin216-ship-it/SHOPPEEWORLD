import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppee_world/user/models/product/product_model.dart';
import 'package:shoppee_world/user/repositories/wishlist_repository.dart';

final wishlistRepositoryProvider =
    Provider<WishlistRepository>((ref) {
  return WishlistRepository();
});

final wishlistProvider =
    FutureProvider<List<ProductModel>>((ref) async {
  final repository =
      ref.read(wishlistRepositoryProvider);

  return repository.getWishlist();
});

final wishlistIdsProvider =
    FutureProvider<Set<int>>((ref) async {
  final repository =
      ref.read(wishlistRepositoryProvider);

  final wishlist = await repository.getWishlist();

  return wishlist.map((product) => product.id).toSet();
});

final wishlistNotifierProvider =
    Provider<WishlistNotifier>((ref) {
  return WishlistNotifier(ref);
});

class WishlistNotifier {
  final Ref ref;

  WishlistNotifier(this.ref);

  Future<void> toggleFavorite({
    required int productId,
  }) async {
    final repository =
        ref.read(wishlistRepositoryProvider);

    final isFav =
        await repository.isFavorite(productId);

    if (isFav) {
      await repository.removeFromWishlist(
        productId: productId,
      );
    } else {
      await repository.addToWishlist(
        productId: productId,
      );
    }

    // Refresh both wishlist states
    ref.invalidate(wishlistProvider);
    ref.invalidate(wishlistIdsProvider);
  }

  Future<bool> isFavorite(int productId) {
    return ref
        .read(wishlistRepositoryProvider)
        .isFavorite(productId);
  }
}