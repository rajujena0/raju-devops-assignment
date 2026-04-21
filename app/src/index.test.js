const request = require('supertest');
const app = require('./index');

describe('Portfolio App Tests', () => {
  test('GET /health returns 200', async () => {
    const res = await request(app).get('/health');
    expect(res.statusCode).toBe(200);
    expect(res.body.status).toBe('healthy');
  });

  test('GET /api/profile returns Raju Jena', async () => {
    const res = await request(app).get('/api/profile');
    expect(res.statusCode).toBe(200);
    expect(res.body.name).toBe('Raju Jena');
    expect(res.body.stats).toHaveLength(4);
  });

  test('GET /api/profile has experience array', async () => {
    const res = await request(app).get('/api/profile');
    expect(Array.isArray(res.body.experience)).toBe(true);
    expect(res.body.experience.length).toBeGreaterThan(0);
  });

  test('GET /api/profile has skills', async () => {
    const res = await request(app).get('/api/profile');
    expect(res.body.skills).toBeDefined();
    expect(res.body.projects).toHaveLength(3);
  });

  test('GET / serves frontend', async () => {
    const res = await request(app).get('/');
    expect(res.statusCode).toBe(200);
  });
});
