function parseInt(value?: string): number {
  if (!value || Number.isNaN(value)) return -1;
  return Number.parseInt(value, 10);
}

function isHexColor(hexColor: string): boolean {
  const regexToCheckIfHexColor = /^#(([0-9A-Fa-f]{2}){3,4}|[0-9A-Fa-f]{3})$/;
  return regexToCheckIfHexColor.test(hexColor);
}

function isNumberBetween(value: number, min: number, max: number): boolean {
  if (value !== 0 && !value) return false;
  return value >= min && value <= max;
}

export function rgbToHex(rgbColor: string): string | null {
  const LENGTH_OF_RGB_COLOR = 3;

  const regexToRemoveCharacters = /[A-Z()\s]/gi;
  const rgbValues = rgbColor
    .toLowerCase()
    .replace(regexToRemoveCharacters, '')
    .split(',');

  if (rgbValues.length !== LENGTH_OF_RGB_COLOR) return null;

  const [red, green, blue] = rgbValues;
  const allColorsExists = !!red && !!green && !!blue;
  if (!allColorsExists) return null;

  const redNumber = parseInt(red);
  const greenNumber = parseInt(green);
  const blueNumber = parseInt(blue);

  if (
    !isNumberBetween(redNumber, 0, 255) ||
    !isNumberBetween(greenNumber, 0, 255) ||
    !isNumberBetween(blueNumber, 0, 255)
  ) {
    return null;
  }

  const byteNumbers =
    (1 << 24) | (redNumber << 16) | (greenNumber << 8) | blueNumber;
  const hexColor = `#${byteNumbers.toString(16).slice(1).toUpperCase()}`;

  if (!isHexColor(hexColor)) return null;
  return hexColor;
}

export function rgbaToHex(rgbaColor: string): string | null {
  const LENGTH_OF_RGBA_COLOR = 4;

  const regexToRemoveCharacters = /[A-Z()\s]/gi;
  const rgbaValues = rgbaColor
    .toLowerCase()
    .replace(regexToRemoveCharacters, '')
    .split(',');

  if (rgbaValues.length !== LENGTH_OF_RGBA_COLOR) return null;

  const [red, green, blue, alpha] = rgbaValues;
  const allColorsExists = !!red && !!green && !!blue && !!alpha;
  if (!allColorsExists) return null;

  const redNumber = parseInt(red);
  const greenNumber = parseInt(green);
  const blueNumber = parseInt(blue);
  const alphaNumber = Number.parseFloat(alpha);

  if (
    !isNumberBetween(redNumber, 0, 255) ||
    !isNumberBetween(greenNumber, 0, 255) ||
    !isNumberBetween(blueNumber, 0, 255) ||
    !isNumberBetween(alphaNumber, 0, 1)
  ) {
    return null;
  }

  const alphaNumericString = (((alpha as any) * 255) | (1 << 8))
    .toString(16)
    .slice(1);
  const byteNumbers =
    (1 << 24) | (redNumber << 16) | (greenNumber << 8) | blueNumber;
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
  return `#${firstChar}${firstChar}${secondChar}${secondChar}${thirdChar}${thirdChar}`.toUpperCase();
}

export function hslToHex(hslColor: string): string | null {
  const LENGTH_OF_HSL_COLOR = 3;

  const regexToRemoveCharacters = /[A-Z()\s%]/gi;
  const hslValues = hslColor
    .toLowerCase()
    .replace(regexToRemoveCharacters, '')
    .split(',');

  if (hslValues.length !== LENGTH_OF_HSL_COLOR) return null;

  const [hue, saturation, lightness] = hslValues;
  const allColorsExists = !!hue && !!saturation && !!lightness;
  if (!allColorsExists) return null;

  const hueNumber = parseInt(hue);
  const saturationNumber = parseInt(saturation);
  let lightnessNumber = parseInt(lightness);

  if (
    !isNumberBetween(hueNumber, 0, 360) ||
    !isNumberBetween(saturationNumber, 0, 100) ||
    !isNumberBetween(lightnessNumber, 0, 100)
  ) {
    return null;
  }

  lightnessNumber /= 100;
  const brightness =
    (saturationNumber * Math.min(lightnessNumber, 1 - lightnessNumber)) / 100;

  const calculateHex = (bytes: number) => {
    const hueValue = (bytes + hueNumber / 30) % 12;
    const maxHueValue = Math.max(Math.min(hueValue - 3, 9 - hueValue, 1), -1);
    const color = lightnessNumber - brightness * maxHueValue;
    return Math.round(255 * color)
      .toString(16)
      .padStart(2, '0');
  };

  const hexColor = '#' + calculateHex(0) + calculateHex(8) + calculateHex(4);

  if (!isHexColor(hexColor.toUpperCase())) return null;
  return hexColor.toUpperCase();
}

export function hslaToHex(hslaColor: string): string | null {
  const LENGTH_OF_HSLA_COLOR = 4;

  const regexToRemoveCharacters = /[A-Z()\s%]/gi;
  const hslaValues = hslaColor
    .toLowerCase()
    .replace(regexToRemoveCharacters, '')
    .split(',');

  if (hslaValues.length !== LENGTH_OF_HSLA_COLOR) return null;

  const [hue, saturation, lightness, alpha] = hslaValues;
  const allColorsExists = !!hue && !!saturation && !!lightness && !!alpha;
  if (!allColorsExists) return null;

  const hueNumber = parseInt(hue);
  const saturationNumber = parseInt(saturation);
  let lightnessNumber = parseInt(lightness);
  const alphaNumber = Number.parseFloat(alpha);

  if (
    !isNumberBetween(hueNumber, 0, 360) ||
    !isNumberBetween(saturationNumber, 0, 100) ||
    !isNumberBetween(lightnessNumber, 0, 100)
  ) {
    return null;
  }

  lightnessNumber /= 100;
  const brightness =
    (saturationNumber * Math.min(lightnessNumber, 1 - lightnessNumber)) / 100;

  const calculateHex = (bytes: number) => {
    const hueValue = (bytes + hueNumber / 30) % 12;
    const maxHueValue = Math.max(Math.min(hueValue - 3, 9 - hueValue, 1), -1);
    const color = lightnessNumber - brightness * maxHueValue;
    return Math.round(255 * color)
      .toString(16)
      .padStart(2, '0');
  };

  const alphaValue = Math.round(alphaNumber * 255)
    .toString(16)
    .padStart(2, '0');
  const hexCharacters =
    '#' + calculateHex(0) + calculateHex(8) + calculateHex(4);
  const hexColor = `${hexCharacters}${alphaValue}`.toUpperCase();

  if (!isHexColor(hexColor)) return null;
  return hexColor;
}
