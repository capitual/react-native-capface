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
  const redGreenAndBlueNumbers = rgbColor
    .toLowerCase()
    .replace(regexToRemoveCharacters, '')
    .split(',');

  if (redGreenAndBlueNumbers.length !== LENGTH_OF_RGB_COLOR) return null;

  const [red, green, blue] = redGreenAndBlueNumbers;
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
  const hexCharacters = byteNumbers.toString(16).slice(1).toUpperCase();
  const hexColor = `#${hexCharacters}`;

  if (!isHexColor(hexColor)) return null;
  return hexColor;
}

export function rgbaToHex(rgbaColor: string): string | null {
  const LENGTH_OF_RGBA_COLOR = 4;

  const regexToRemoveCharacters = /[A-Z()\s]/gi;
  const redGreenAndBlueNumbers = rgbaColor
    .toLowerCase()
    .replace(regexToRemoveCharacters, '')
    .split(',');

  if (redGreenAndBlueNumbers.length !== LENGTH_OF_RGBA_COLOR) return null;

  const [red, green, blue, alpha] = redGreenAndBlueNumbers;
  const allColorsExists = !!red && !!green && !!blue && !!alpha;
  if (!allColorsExists) return null;

  const redNumber = parseInt(red);
  const greenNumber = parseInt(green);
  const blueNumber = parseInt(blue);
  const alphaNumber = parseInt(alpha);

  if (
    !isNumberBetween(redNumber, 0, 255) ||
    !isNumberBetween(greenNumber, 0, 255) ||
    !isNumberBetween(blueNumber, 0, 255) ||
    !isNumberBetween(alphaNumber, 0, 1)
  ) {
    return null;
  }

  const redNumericString = redNumber.toString(16);
  const greenNumericString = greenNumber.toString(16);
  const blueNumericString = blueNumber.toString(16);
  const alphaNumericString = alphaNumber.toString(16).slice(1);

  const hexColor =
    `#${redNumericString}${greenNumericString}${blueNumericString}${alphaNumericString}`.toUpperCase();

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
