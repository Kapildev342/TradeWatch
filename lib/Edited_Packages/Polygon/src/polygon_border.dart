import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tradewatchfinal/Edited_Packages/Polygon/src/polygon.dart';

import 'corner_path_effect.dart';

/// The relative position of the stroke on a [BorderSide] in a [Border] or [OutlinedBorder].
/// When set to [inside], the stroke is drawn completely inside the widget.
/// For [center] and [outside], a property such as [Container.clipBehavior]
/// can be used in an outside widget to clip it.
/// If [Container.decoration] has a border, the container may incorporate
/// [BorderSide.width] as additional padding:
/// - [inside] provides padding with full [BorderSide.width].
/// - [center] provides padding with half [BorderSide.width].
/// - [outside] provides zero padding, as stroke is drawn entirely outside.
enum BorderAlign {
  /// The border is drawn on the inside of the border path.
  inside,

  /// The border is drawn on the center of the border path, with half of the
  /// [BorderSide.width] on the inside, and the other half on the outside of the path.
  center,

  /// The border is drawn on the outside of the border path.
  outside,
}

/// A polygon border.
///
/// Typically used with [ShapeDecoration] to draw a box with a polygon.
class PolygonBorder extends OutlinedBorder {
  /// Creates a polygon border.
  const PolygonBorder({
    required this.polygon,
    this.cornerPathEffect = const DefaultCornerPathEffect(),
    this.radius = 0,
    this.turn = 0,
    this.borderAlign = BorderAlign.inside,
    required BorderSide side,
  });

  /// The polygon.
  final Polygon polygon;

  /// The effect used to curve the corners.
  final CornerPathEffect cornerPathEffect;

  /// The radius for each corner.
  final double radius;

  /// Describes the rotation (in term of turns) of the polygon.
  final double turn;

  /// The direction of where the border will be drawn relative to the container.
  final BorderAlign borderAlign;

  @override
  EdgeInsetsGeometry get dimensions {
    switch (borderAlign) {
      case BorderAlign.inside:
        return EdgeInsets.all(side.width);
      case BorderAlign.center:
        return EdgeInsets.all(side.width / 2);
      case BorderAlign.outside:
        return EdgeInsets.zero;
    }
  }

  @override
  ShapeBorder scale(double t) {
    return PolygonBorder(
      polygon: polygon,
      cornerPathEffect: cornerPathEffect,
      side: side.scale(t),
      radius: radius * t,
      turn: turn,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is PolygonBorder) {
      return PolygonBorder(
        polygon: polygon,
        borderAlign: borderAlign,
        cornerPathEffect: cornerPathEffect,
        radius: lerpDouble(a.radius, radius, t) ?? 0,
        side: BorderSide.lerp(a.side, side, t),
        turn: lerpDouble(a.turn, turn, t) ?? 0,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is PolygonBorder) {
      return PolygonBorder(
        polygon: polygon,
        borderAlign: borderAlign,
        cornerPathEffect: cornerPathEffect,
        radius: lerpDouble(radius, b.radius, t) ?? 0,
        side: BorderSide.lerp(side, b.side, t),
        turn: lerpDouble(turn, b.turn, t) ?? 0,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final delta = () {
      switch (borderAlign) {
        case BorderAlign.inside:
          return -side.width;
        case BorderAlign.center:
          return -side.width / 2;
        case BorderAlign.outside:
          return 0.0;
      }
    }();
    return polygon.computePath(
      rect: rect.inflate(delta),
      radius: radius + delta,
      turn: turn,
      cornerPathEffect: cornerPathEffect,
    );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return polygon.computePath(
      rect: rect,
      radius: radius,
      turn: turn,
      cornerPathEffect: cornerPathEffect,
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        // Since the stroke is painted at the center, we need to adjust the rect
        // according to the [borderAlign].
        final delta = () {
          switch (borderAlign) {
            case BorderAlign.inside:
              return -side.width / 2;
            case BorderAlign.center:
              return 0.0;
            case BorderAlign.outside:
              return side.width / 2;
          }
        }();

        canvas.drawPath(
          polygon.computePath(
            rect: rect.inflate(delta),
            radius: radius == 0 ? 0 : radius + delta,
            turn: turn,
            cornerPathEffect: cornerPathEffect,
          ),
          side.toPaint(),
        );
        break;
    }
  }

  @override
  OutlinedBorder copyWith({BorderSide? side}) {
    return PolygonBorder(
      polygon: polygon,
      cornerPathEffect: cornerPathEffect,
      side: side ?? this.side,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is PolygonBorder &&
        other.borderAlign == borderAlign &&
        other.cornerPathEffect == cornerPathEffect &&
        other.polygon == polygon &&
        other.radius == radius &&
        other.turn == turn &&
        other.side == side;
  }

  @override
  int get hashCode => Object.hashAll([
        borderAlign,
        cornerPathEffect,
        polygon,
        radius,
        turn,
        side,
      ]);
}
