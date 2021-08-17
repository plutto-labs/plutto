/* eslint-env jest */
import { mutations, getters } from './auth';

const { setUserData } = mutations;

describe('mutations', () => {
  it('sets user data', () => {
    const state = {
      token: null,
      email: null,
    };

    setUserData(state, { email: 'test@test.com', authenticationToken: 'A' });

    expect(state).toMatchObject({ email: 'test@test.com', token: 'A' });
  });
});

jest.mock('../api/auth');

const { isLoggedIn } = getters;

describe('getters', () => {
  describe('isLoggedIn', () => {
    it('returns true if logged in', () => {
      const state = { token: 'A' };
      const loginStatus = isLoggedIn(state);

      expect(loginStatus).toEqual(true);
    });

    it('returns false if logged out', () => {
      const state = { token: null };
      const loginStatus = isLoggedIn(state);

      expect(loginStatus).toEqual(false);
    });
  });
});
