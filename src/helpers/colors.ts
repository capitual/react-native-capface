function isHexColor(hexColor: string): boolean {
  const regexToCheckIfHexColor = /^#(([0-9A-Fa-f]{2}){3,4}|[0-9A-Fa-f]{3})$/;
  return regexToCheckIfHexColor.test(hexColor);
}

function isNumberBetween(value: number, min: number, max: number): boolean {
  if (value !== 0 && !value) return false;
  return value >= min && value <= max;
}

function calculateHslHex(
  bytes: number,
  hue: number,
  lightness: number,
  saturation: number
): string {
  const lightnessDivide = lightness / 100;
  const brightness =
    (saturation * Math.min(lightnessDivide, 1 - lightnessDivide)) / 100;
  const hueValue = (bytes + hue / 30) % 12;
  const maxHueValue = Math.max(Math.min(hueValue - 3, 9 - hueValue, 1), -1);
  const color = lightnessDivide - brightness * maxHueValue;
  return Math.round(255 * color)
    .toString(16)
    .padStart(2, '0');
}

type ColorTableType = 'RGB' | 'RGBA' | 'HSL' | 'HSLA';

function isBetweenLimits(type: ColorTableType, colors: number[]): boolean {
  const hasAlpha = type === 'HSLA' || type === 'RGBA';
  const isRgb = type === 'RGBA' || type === 'RGB';

  const [firstColor, secondColor, thirdColor, alpha] = colors;
  const isValid =
    isNumberBetween(firstColor!, 0, isRgb ? 255 : 360) &&
    isNumberBetween(secondColor!, 0, isRgb ? 255 : 100) &&
    isNumberBetween(thirdColor!, 0, isRgb ? 255 : 100);

  if (hasAlpha) return isValid && isNumberBetween(alpha!, 0, 1);
  return isValid;
}

function getColorTable(type: ColorTableType, color: string): number[] | null {
  const hasAlpha = type === 'HSLA' || type === 'RGBA';
  const COLOR_LENGTH = hasAlpha ? 4 : 3;

  const regexToRemoveCharacters = hasAlpha ? /[A-Z()\s%]/gi : /[A-Z()\s]/gi;
  const tableValues = color
    .toLowerCase()
    .replace(regexToRemoveCharacters, '')
    .split(',');

  if (tableValues.length !== COLOR_LENGTH) return null;

  const [firstColor, secondColor, thirdColor] = tableValues;
  if (hasAlpha && tableValues.every((value) => !!value)) {
    return tableValues.map((value, index) => {
      if (index !== COLOR_LENGTH - 1) return Number.parseFloat(value);
      return Number.parseInt(value, 10);
    });
  }

  const hasEveryColors = !!firstColor && !!secondColor && !!thirdColor;
  return hasEveryColors
    ? tableValues.map((value) => Number.parseInt(value, 10))
    : null;
}

export function rgbToHex(rgbColor: string): string | null {
  const colorTable = getColorTable('RGB', rgbColor);
  if (!colorTable) return null;

  if (!isBetweenLimits('RGB', colorTable)) return null;
  const [red, green, blue] = colorTable;

  const byteNumbers = (1 << 24) | (red! << 16) | (green! << 8) | blue!;
  const hexColor = `#${byteNumbers.toString(16).slice(1).toUpperCase()}`;

  if (!isHexColor(hexColor)) return null;
  return hexColor;
}

export function rgbaToHex(rgbaColor: string): string | null {
  const colorTable = getColorTable('RGBA', rgbaColor);
  if (!colorTable) return null;

  if (!isBetweenLimits('RGBA', colorTable)) return null;
  const [red, green, blue, alpha] = colorTable;

  const alphaNumericString = (((alpha! as any) * 255) | (1 << 8))
    .toString(16)
    .slice(1);
  const byteNumbers = (1 << 24) | (red! << 16) | (green! << 8) | blue!;
  const hexColor = `#${byteNumbers
    .toString(16)
    .slice(1)}${alphaNumericString}`.toUpperCase();

  if (!isHexColor(hexColor)) return null;
  return hexColor;
}

export function formatHexColor(hexColor: string): string | null {
  if (!isHexColor(hexColor)) return null;
  const MIN_LENGTH_HEX_COLOR = 4;
  const MIDDLE_LENGTH_HEX_COLOR = 7;
  const MAX_LENGTH_HEX_COLOR = 9;

  const isMiddleHexColor = hexColor.length === MIDDLE_LENGTH_HEX_COLOR;
  const isMaxHexColor = hexColor.length === MAX_LENGTH_HEX_COLOR;
  if (isMiddleHexColor || isMaxHexColor) return hexColor;

  if (hexColor.length !== MIN_LENGTH_HEX_COLOR) return null;

  const [firstChar, secondChar, thirdChar] = hexColor.slice(1);
  const redHexColor = firstChar!.repeat(2);
  const greenHexColor = secondChar!.repeat(2);
  const blueHexColor = thirdChar!.repeat(2);

  return `#${redHexColor}${greenHexColor}${blueHexColor}`.toUpperCase();
}

export function hslToHex(hslColor: string): string | null {
  const colorTable = getColorTable('HSL', hslColor);
  if (!colorTable) return null;

  if (!isBetweenLimits('HSL', colorTable)) return null;
  const [hue, saturation, lightness] = colorTable;

  const redHexColor = calculateHslHex(0, hue!, lightness!, saturation!);
  const greenHexColor = calculateHslHex(8, hue!, lightness!, saturation!);
  const blueHexColor = calculateHslHex(4, hue!, lightness!, saturation!);

  const hexColor =
    `#${redHexColor}${greenHexColor}${blueHexColor}`.toUpperCase();

  if (!isHexColor(hexColor)) return null;
  return hexColor;
}

export function hslaToHex(hslaColor: string): string | null {
  const colorTable = getColorTable('HSLA', hslaColor);
  if (!colorTable) return null;

  if (!isBetweenLimits('HSLA', colorTable)) return null;
  const [hue, saturation, lightness, alpha] = colorTable;

  const redHexColor = calculateHslHex(0, hue!, lightness!, saturation!);
  const greenHexColor = calculateHslHex(8, hue!, lightness!, saturation!);
  const blueHexColor = calculateHslHex(4, hue!, lightness!, saturation!);
  const alphaValue = Math.round(alpha! * 255)
    .toString(16)
    .padStart(2, '0');

  const hexColor =
    `#${redHexColor}${greenHexColor}${blueHexColor}${alphaValue}`.toUpperCase();

  if (!isHexColor(hexColor)) return null;
  return hexColor;
}
