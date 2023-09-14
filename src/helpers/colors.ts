function parseFloat(value?: string): number {
  if (!value || Number.isNaN(value)) return -1;

  return Number.parseFloat(value);
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

  return '#' + byteNumbers.toString(16).slice(1).toUpperCase();
}
