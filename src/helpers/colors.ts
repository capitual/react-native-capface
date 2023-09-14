function parseFloat(value?: string): number {
  if (!value || Number.isNaN(value)) return -1;

  return Number.parseFloat(value);
}

function isHexColor(hexColor: string): boolean {
  const regexToCheckIfHexColor = /^#(([0-9A-Fa-f]{2}){3,4}|[0-9A-Fa-f]{3})$/;
  return regexToCheckIfHexColor.test(hexColor);
}

function isRgbNumber(numberColor: number): boolean {
  if (numberColor !== 0 && !numberColor) return false;

  const MIN_NUMBER_COLOR = 0;
  const MAX_NUMBER_COLOR = 255;

  return numberColor >= MIN_NUMBER_COLOR && numberColor <= MAX_NUMBER_COLOR;
}

export function rgbToHexadecimal(rgbColor: string): string | null {
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

  const redNumber = parseFloat(red);
  const greenNumber = parseFloat(green);
  const blueNumber = parseFloat(blue);

  if (
    !isRgbNumber(redNumber) ||
    !isRgbNumber(greenNumber) ||
    !isRgbNumber(blueNumber)
  ) {
    return null;
  }

  const byteNumbers =
    (1 << 24) | (redNumber << 16) | (greenNumber << 8) | blueNumber;

  const hexColor = '#' + byteNumbers.toString(16).slice(1).toUpperCase();

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
  return `#${firstChar}${firstChar}${secondChar}${secondChar}${thirdChar}${thirdChar}`;
}
