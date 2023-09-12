import type { CapfaceSdk } from '..';

export const NATIVE_CONSTANTS = (
  data?: Omit<CapfaceSdk.MatchConfig, 'key' | 'hasExternalDatabaseRefID'>
): Record<CapfaceSdk.MatchType, CapfaceSdk.MatchConfig> => ({
  authenticate: {
    key: 'authenticateMessage',
    hasExternalDatabaseRefID: true,
    parameters: data?.parameters || null,
    endpoint: data?.endpoint || '/match-3d-3d',
    successMessage: data?.successMessage || 'Authenticated',
  },
  enroll: {
    key: 'enrollMessage',
    hasExternalDatabaseRefID: true,
    parameters: data?.parameters || null,
    endpoint: data?.endpoint || '/enrollment-3d',
    successMessage: data?.successMessage || 'Liveness\nConfirmed',
  },
  liveness: {
    key: 'livenessMessage',
    hasExternalDatabaseRefID: false,
    parameters: data?.parameters || null,
    endpoint: data?.endpoint || '/liveness-3d',
    successMessage: data?.successMessage || 'Liveness\nConfirmed',
  },
});
