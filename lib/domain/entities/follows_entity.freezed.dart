// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'follows_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FollowsEntity {
  String get followId => throw _privateConstructorUsedError;
  String get followerId => throw _privateConstructorUsedError;
  String get followedId => throw _privateConstructorUsedError;
  FollowStatus get status => throw _privateConstructorUsedError;

  /// Create a copy of FollowsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FollowsEntityCopyWith<FollowsEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FollowsEntityCopyWith<$Res> {
  factory $FollowsEntityCopyWith(
          FollowsEntity value, $Res Function(FollowsEntity) then) =
      _$FollowsEntityCopyWithImpl<$Res, FollowsEntity>;
  @useResult
  $Res call(
      {String followId,
      String followerId,
      String followedId,
      FollowStatus status});
}

/// @nodoc
class _$FollowsEntityCopyWithImpl<$Res, $Val extends FollowsEntity>
    implements $FollowsEntityCopyWith<$Res> {
  _$FollowsEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FollowsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? followId = null,
    Object? followerId = null,
    Object? followedId = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      followId: null == followId
          ? _value.followId
          : followId // ignore: cast_nullable_to_non_nullable
              as String,
      followerId: null == followerId
          ? _value.followerId
          : followerId // ignore: cast_nullable_to_non_nullable
              as String,
      followedId: null == followedId
          ? _value.followedId
          : followedId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FollowStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FollowsEntityImplCopyWith<$Res>
    implements $FollowsEntityCopyWith<$Res> {
  factory _$$FollowsEntityImplCopyWith(
          _$FollowsEntityImpl value, $Res Function(_$FollowsEntityImpl) then) =
      __$$FollowsEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String followId,
      String followerId,
      String followedId,
      FollowStatus status});
}

/// @nodoc
class __$$FollowsEntityImplCopyWithImpl<$Res>
    extends _$FollowsEntityCopyWithImpl<$Res, _$FollowsEntityImpl>
    implements _$$FollowsEntityImplCopyWith<$Res> {
  __$$FollowsEntityImplCopyWithImpl(
      _$FollowsEntityImpl _value, $Res Function(_$FollowsEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of FollowsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? followId = null,
    Object? followerId = null,
    Object? followedId = null,
    Object? status = null,
  }) {
    return _then(_$FollowsEntityImpl(
      followId: null == followId
          ? _value.followId
          : followId // ignore: cast_nullable_to_non_nullable
              as String,
      followerId: null == followerId
          ? _value.followerId
          : followerId // ignore: cast_nullable_to_non_nullable
              as String,
      followedId: null == followedId
          ? _value.followedId
          : followedId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FollowStatus,
    ));
  }
}

/// @nodoc

class _$FollowsEntityImpl implements _FollowsEntity {
  const _$FollowsEntityImpl(
      {required this.followId,
      required this.followerId,
      required this.followedId,
      required this.status});

  @override
  final String followId;
  @override
  final String followerId;
  @override
  final String followedId;
  @override
  final FollowStatus status;

  @override
  String toString() {
    return 'FollowsEntity(followId: $followId, followerId: $followerId, followedId: $followedId, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FollowsEntityImpl &&
            (identical(other.followId, followId) ||
                other.followId == followId) &&
            (identical(other.followerId, followerId) ||
                other.followerId == followerId) &&
            (identical(other.followedId, followedId) ||
                other.followedId == followedId) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, followId, followerId, followedId, status);

  /// Create a copy of FollowsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FollowsEntityImplCopyWith<_$FollowsEntityImpl> get copyWith =>
      __$$FollowsEntityImplCopyWithImpl<_$FollowsEntityImpl>(this, _$identity);
}

abstract class _FollowsEntity implements FollowsEntity {
  const factory _FollowsEntity(
      {required final String followId,
      required final String followerId,
      required final String followedId,
      required final FollowStatus status}) = _$FollowsEntityImpl;

  @override
  String get followId;
  @override
  String get followerId;
  @override
  String get followedId;
  @override
  FollowStatus get status;

  /// Create a copy of FollowsEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FollowsEntityImplCopyWith<_$FollowsEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$FollowCheckResult {
  bool get isFollowing => throw _privateConstructorUsedError;
  bool get isFollowedBy => throw _privateConstructorUsedError;
  FollowStatus get status => throw _privateConstructorUsedError;

  /// Create a copy of FollowCheckResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FollowCheckResultCopyWith<FollowCheckResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FollowCheckResultCopyWith<$Res> {
  factory $FollowCheckResultCopyWith(
          FollowCheckResult value, $Res Function(FollowCheckResult) then) =
      _$FollowCheckResultCopyWithImpl<$Res, FollowCheckResult>;
  @useResult
  $Res call({bool isFollowing, bool isFollowedBy, FollowStatus status});
}

/// @nodoc
class _$FollowCheckResultCopyWithImpl<$Res, $Val extends FollowCheckResult>
    implements $FollowCheckResultCopyWith<$Res> {
  _$FollowCheckResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FollowCheckResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isFollowing = null,
    Object? isFollowedBy = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      isFollowing: null == isFollowing
          ? _value.isFollowing
          : isFollowing // ignore: cast_nullable_to_non_nullable
              as bool,
      isFollowedBy: null == isFollowedBy
          ? _value.isFollowedBy
          : isFollowedBy // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FollowStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FollowCheckResultImplCopyWith<$Res>
    implements $FollowCheckResultCopyWith<$Res> {
  factory _$$FollowCheckResultImplCopyWith(_$FollowCheckResultImpl value,
          $Res Function(_$FollowCheckResultImpl) then) =
      __$$FollowCheckResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isFollowing, bool isFollowedBy, FollowStatus status});
}

/// @nodoc
class __$$FollowCheckResultImplCopyWithImpl<$Res>
    extends _$FollowCheckResultCopyWithImpl<$Res, _$FollowCheckResultImpl>
    implements _$$FollowCheckResultImplCopyWith<$Res> {
  __$$FollowCheckResultImplCopyWithImpl(_$FollowCheckResultImpl _value,
      $Res Function(_$FollowCheckResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of FollowCheckResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isFollowing = null,
    Object? isFollowedBy = null,
    Object? status = null,
  }) {
    return _then(_$FollowCheckResultImpl(
      isFollowing: null == isFollowing
          ? _value.isFollowing
          : isFollowing // ignore: cast_nullable_to_non_nullable
              as bool,
      isFollowedBy: null == isFollowedBy
          ? _value.isFollowedBy
          : isFollowedBy // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FollowStatus,
    ));
  }
}

/// @nodoc

class _$FollowCheckResultImpl implements _FollowCheckResult {
  const _$FollowCheckResultImpl(
      {required this.isFollowing,
      required this.isFollowedBy,
      required this.status});

  @override
  final bool isFollowing;
  @override
  final bool isFollowedBy;
  @override
  final FollowStatus status;

  @override
  String toString() {
    return 'FollowCheckResult(isFollowing: $isFollowing, isFollowedBy: $isFollowedBy, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FollowCheckResultImpl &&
            (identical(other.isFollowing, isFollowing) ||
                other.isFollowing == isFollowing) &&
            (identical(other.isFollowedBy, isFollowedBy) ||
                other.isFollowedBy == isFollowedBy) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isFollowing, isFollowedBy, status);

  /// Create a copy of FollowCheckResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FollowCheckResultImplCopyWith<_$FollowCheckResultImpl> get copyWith =>
      __$$FollowCheckResultImplCopyWithImpl<_$FollowCheckResultImpl>(
          this, _$identity);
}

abstract class _FollowCheckResult implements FollowCheckResult {
  const factory _FollowCheckResult(
      {required final bool isFollowing,
      required final bool isFollowedBy,
      required final FollowStatus status}) = _$FollowCheckResultImpl;

  @override
  bool get isFollowing;
  @override
  bool get isFollowedBy;
  @override
  FollowStatus get status;

  /// Create a copy of FollowCheckResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FollowCheckResultImplCopyWith<_$FollowCheckResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$FollowsInput {
  String get userId => throw _privateConstructorUsedError;
  String get targetUserId => throw _privateConstructorUsedError;

  /// Create a copy of FollowsInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FollowsInputCopyWith<FollowsInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FollowsInputCopyWith<$Res> {
  factory $FollowsInputCopyWith(
          FollowsInput value, $Res Function(FollowsInput) then) =
      _$FollowsInputCopyWithImpl<$Res, FollowsInput>;
  @useResult
  $Res call({String userId, String targetUserId});
}

/// @nodoc
class _$FollowsInputCopyWithImpl<$Res, $Val extends FollowsInput>
    implements $FollowsInputCopyWith<$Res> {
  _$FollowsInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FollowsInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? targetUserId = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      targetUserId: null == targetUserId
          ? _value.targetUserId
          : targetUserId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FollowsInputImplCopyWith<$Res>
    implements $FollowsInputCopyWith<$Res> {
  factory _$$FollowsInputImplCopyWith(
          _$FollowsInputImpl value, $Res Function(_$FollowsInputImpl) then) =
      __$$FollowsInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userId, String targetUserId});
}

/// @nodoc
class __$$FollowsInputImplCopyWithImpl<$Res>
    extends _$FollowsInputCopyWithImpl<$Res, _$FollowsInputImpl>
    implements _$$FollowsInputImplCopyWith<$Res> {
  __$$FollowsInputImplCopyWithImpl(
      _$FollowsInputImpl _value, $Res Function(_$FollowsInputImpl) _then)
      : super(_value, _then);

  /// Create a copy of FollowsInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? targetUserId = null,
  }) {
    return _then(_$FollowsInputImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      targetUserId: null == targetUserId
          ? _value.targetUserId
          : targetUserId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FollowsInputImpl implements _FollowsInput {
  const _$FollowsInputImpl({required this.userId, required this.targetUserId});

  @override
  final String userId;
  @override
  final String targetUserId;

  @override
  String toString() {
    return 'FollowsInput(userId: $userId, targetUserId: $targetUserId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FollowsInputImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.targetUserId, targetUserId) ||
                other.targetUserId == targetUserId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId, targetUserId);

  /// Create a copy of FollowsInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FollowsInputImplCopyWith<_$FollowsInputImpl> get copyWith =>
      __$$FollowsInputImplCopyWithImpl<_$FollowsInputImpl>(this, _$identity);
}

abstract class _FollowsInput implements FollowsInput {
  const factory _FollowsInput(
      {required final String userId,
      required final String targetUserId}) = _$FollowsInputImpl;

  @override
  String get userId;
  @override
  String get targetUserId;

  /// Create a copy of FollowsInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FollowsInputImplCopyWith<_$FollowsInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
