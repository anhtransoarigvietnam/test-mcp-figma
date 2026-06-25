---
description: Flutter data layer skill
paths:
-e   - **/*_test.dart
  - **/test/**
---
Summary: Data layer conventions using Retrofit Data Sources, DTOs mapped to Domain Models, and Repositories.

# Data Layer

The application splits data handling across three concepts: Data Sources, DTOs, and Domain Repositories.

## 1. Data Sources (Retrofit + Dio)
Located in `lib/network/data_source/`. Defined as abstract classes using `@RestApi()` and injected using `injectable`.

```dart
@lazySingleton
@RestApi()
abstract class CoinDataSource {
  @factoryMethod
  factory CoinDataSource(@Named('appDio') Dio dio) = _CoinDataSource;

  @GET(ApiEndpoint.coinDetail)
  Future<CoinResponseDto> getCoinDetail({
    @Path('id') required String id,
    @Query('source_scan_job_id') int? scanJobId,
  });
}
```

## 2. DTOs and Serialization
Located in `lib/network/dto/`. Uses `json_annotation`. DTOs must provide a `toDomain()` method to convert API models to plain Domain models.

```dart
@JsonSerializable(createToJson: false)
class CoinResponseDto {
  const CoinResponseDto({this.coin, this.userCoin});
  final CoinDto? coin;
  
  @JsonKey(name: 'userCoinImages')
  final UserCoinImagesDto? userCoin;

  factory CoinResponseDto.fromJson(Map<String, dynamic> json) => _$CoinResponseDtoFromJson(json);

  Coin toDomain() {
    return Coin(
      id: coin?.id,
      displayName: coin?.displayName,
      // map fields...
    );
  }
}
```

## 3. Domain Models
Located in `lib/domain/model/`. Plain Dart classes. No JSON serialization logic allowed here.

```dart
class Coin {
  const Coin({this.id, this.displayName, this.country});
  final int? id;
  final String? displayName;
  final String? country;
}
```

## 4. Repositories
Interfaces are defined in `lib/domain/repository/`. Implementations live in `lib/network/repository_implementation/` and return `Result<T>`.

```dart
@LazySingleton(as: CoinRepository)
class CoinRepositoryImpl implements CoinRepository {
  CoinRepositoryImpl(this._coinDataSource);
  final CoinDataSource _coinDataSource;

  @override
  Future<Result<Coin>> getCoinDetail({required String id}) async {
    try {
      final response = await _coinDataSource.getCoinDetail(id: id);
      return Result.success(response.toDomain());
    } catch (e) {
      return Result.error(e);
    }
  }
}
```
