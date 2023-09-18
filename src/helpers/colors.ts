type ColorType = 'HEX' | 'RGB' | 'RGBA' | 'HSL' | 'HSLA';
type ColorTableType = Exclude<ColorType, 'HEX'>;

function isColor(type: ColorType, color: string): boolean {
  const regexsColors: Record<ColorType, RegExp> = {
    HEX: /^#(([0-9A-Fa-f]{2}){3,4}|[0-9A-Fa-f]{3,4})$/,
    HSL: /[Hh][Ss][Ll][(](((([\d]{1,3}|[\d%]{2,4})[,]{0,1})[\s]*){3})[)]/gm,
    HSLA: /[Hh][Ss][Ll][Aa][(](((([\d]{1,3}|[\d%]{2,4}|[\d.]{1,3})[,]{0,1})[\s]*){4})[)]/gm,
    RGB: /[Rr][Gg][Bb][(](((([\d]{1,3})[,]{0,1})[\s]*){3})[)]/gm,
    RGBA: /[Rr][Gg][Bb][Aa][(](((([\d]{1,3}|[\d.]{1,3})[,]{0,1})[\s]*){4})[)]/gm,
  };
  return regexsColors[type].test(color);
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

function isBetweenLimits(type: ColorTableType, colors: number[]): boolean {
  const hasAlpha = type === 'HSLA' || type === 'RGBA';
  const isRgb = type === 'RGBA' || type === 'RGB';

  const [firstColor, secondColor, thirdColor, alpha] = colors;
  const isValidColor =
    isNumberBetween(firstColor!, 0, isRgb ? 255 : 360) &&
    isNumberBetween(secondColor!, 0, isRgb ? 255 : 100) &&
    isNumberBetween(thirdColor!, 0, isRgb ? 255 : 100);

  if (hasAlpha) return isValidColor && isNumberBetween(alpha!, 0, 1);
  return isValidColor;
}

function getColorTable(type: ColorTableType, color: string): number[] | null {
  const hasAlpha = type === 'HSLA' || type === 'RGBA';
  const isHsl = type === 'HSL' || type === 'HSLA';
  const COLOR_LENGTH = hasAlpha ? 4 : 3;

  const regexToRemoveCharacters = isHsl ? /[A-Z()\s%]/gi : /[A-Z()\s]/gi;
  const tableValues = color
    .toLowerCase()
    .replace(regexToRemoveCharacters, '')
    .split(',');

  if (tableValues.length !== COLOR_LENGTH) return null;

  const tableValuesAsNumber = tableValues.map((value, index) => {
    if (hasAlpha && index === COLOR_LENGTH - 1) return Number.parseFloat(value);
    return Number.parseInt(value, 10);
  });

  if (hasAlpha && tableValues.every((value) => !!value)) {
    return tableValuesAsNumber;
  }

  return tableValues.every((value) => !!value) ? tableValuesAsNumber : null;
}

function formatHexColor(hexColor: string): string | null {
  if (!isColor('HEX', hexColor)) return null;
  const MIN_LENGTH_HEX_COLOR = 4;
  const MIN_LENGTH_HEX_ALPHA_COLOR = 5;
  const MAX_LENGTH_HEX_COLOR = 7;
  const MAX_LENGTH_HEX_ALPHA_COLOR = 9;

  const isMiddleHexColor = hexColor.length === MAX_LENGTH_HEX_COLOR;
  const isMaxHexAlphaColor = hexColor.length === MAX_LENGTH_HEX_ALPHA_COLOR;
  if (isMiddleHexColor || isMaxHexAlphaColor) return hexColor;

  const isMinHexColor = hexColor.length !== MIN_LENGTH_HEX_COLOR;
  const isMinHexAlphaColor = hexColor.length !== MIN_LENGTH_HEX_ALPHA_COLOR;
  if (isMinHexColor && isMinHexAlphaColor) return null;

  const [firstChar, secondChar, thirdChar, alpha] = hexColor.slice(1);
  const redHexColor = firstChar!.repeat(2);
  const greenHexColor = secondChar!.repeat(2);
  const blueHexColor = thirdChar!.repeat(2);
  const alphaHexColor = alpha?.repeat(2);

  const color = `#${redHexColor}${greenHexColor}${blueHexColor}${
    alphaHexColor || ''
  }`.toUpperCase();

  if (!isColor('HEX', color)) return null;
  return color;
}

function rgbToHex(rgbColor: string): string | null {
  const colorTable = getColorTable('RGB', rgbColor);
  if (!colorTable) return null;

  if (!isBetweenLimits('RGB', colorTable)) return null;

  const [red, green, blue] = colorTable;
  const byteNumbers = (1 << 24) | (red! << 16) | (green! << 8) | blue!;
  const hexColor = `#${byteNumbers.toString(16).slice(1).toUpperCase()}`;

  if (!isColor('HEX', hexColor)) return null;
  return hexColor;
}

function rgbaToHex(rgbaColor: string): string | null {
  const colorTable = getColorTable('RGBA', rgbaColor);
  if (!colorTable) return null;

  if (!isBetweenLimits('RGBA', colorTable)) return null;
  const [red, green, blue, alpha] = colorTable;

  const alphaNumeric = Math.round(alpha! * 255)
    .toString(16)
    .padStart(2, '0');
  const byteNumbers = (1 << 24) | (red! << 16) | (green! << 8) | blue!;
  const hexColor = `#${byteNumbers
    .toString(16)
    .slice(1)}${alphaNumeric}`.toUpperCase();

  if (!isColor('HEX', hexColor)) return null;
  return hexColor;
}

function hslToHex(hslColor: string): string | null {
  const colorTable = getColorTable('HSL', hslColor);
  if (!colorTable) return null;

  if (!isBetweenLimits('HSL', colorTable)) return null;
  const [hue, saturation, lightness] = colorTable;

  const redHexColor = calculateHslHex(0, hue!, lightness!, saturation!);
  const greenHexColor = calculateHslHex(8, hue!, lightness!, saturation!);
  const blueHexColor = calculateHslHex(4, hue!, lightness!, saturation!);

  const hexColor =
    `#${redHexColor}${greenHexColor}${blueHexColor}`.toUpperCase();

  if (!isColor('HEX', hexColor)) return null;
  return hexColor;
}

function hslaToHex(hslaColor: string): string | null {
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

  if (!isColor('HEX', hexColor)) return null;
  return hexColor;
}

/**
 * @description Calculates a hexadecimal, RGB, RGBA, HSL or HSLA color from a
 * hexadecimal color provided as a string.
 *
 * @param color - A color in hexadecimal, RGB, RGBA, HSL or HSLA format to be
 * converted to a hexadecimal color string.
 *
 * @returns {string|null}
 */
export function convertToHexColor(color: string): string | null {
  if (isColor('HEX', color)) return formatHexColor(color);
  if (isColor('RGB', color)) return rgbToHex(color);
  if (isColor('RGBA', color)) return rgbaToHex(color);
  if (isColor('HSL', color)) return hslToHex(color);
  if (isColor('HSLA', color)) return hslaToHex(color);
  return null;
}
