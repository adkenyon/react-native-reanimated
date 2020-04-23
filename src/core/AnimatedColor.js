import AnimatedNode from './AnimatedNode';
import { Platform } from 'react-native';
import invariant from 'fbjs/lib/invariant';
export { createAnimatedConcat as concat } from './AnimatedConcat';
import { createAnimatedCond as cond } from './AnimatedCond';
export { adapt } from './AnimatedBlock';

class AnimatedColor extends AnimatedNode {
  _inputs;

  constructor(r, g, b, a) {
    // inputs.forEach(input => {
    //   invariant(
    //     input instanceof AnimatedNode || typeof input === 'number',
    //     `Reanimated: Animated.color node arguments should be of type AnimatedNode or Number but got ${input}`
    //   )
    // })
    super(
      { type: 'color', r, g, b, a },
      [r, g, b, a]
    );

    this._inputs = [r, g, b, a];
  }

  toString() {
    return `AnimatedColor, id: ${this.__nodeID}`;
  }

  __onEvaluate() {
    let [r, g, b, a] = this._inputs;

    if (Platform.OS === 'web') {
      // doesn't support bit shifting
      return concat('rgba(', r, ',', g, ',', b, ',', a, ')');
    }

    if (a instanceof AnimatedNode) {
      a = round(multiply(a, 255));
    } else {
      a = Math.round(a * 255);
    }

    const color = add(
      multiply(a, 1 << 24),
      multiply(round(r), 1 << 16),
      multiply(round(g), 1 << 8),
      round(b)
    );
    
    if (Platform.OS === 'android') {
      // on Android color is represented as signed 32 bit int
      return cond(
        lessThan(color, (1 << 31) >>> 0),
        color,
        sub(color, Math.pow(2, 32))
      );
    }
    return color;
  }
}

export function createAnimatedColor(r, g, b, a = 1) {
  return new AnimatedColor(adapt(r), adapt(g), adapt(b), adapt(a));
}
