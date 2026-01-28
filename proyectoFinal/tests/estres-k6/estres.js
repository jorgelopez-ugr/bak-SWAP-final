import http from 'k6/http';
import { check, sleep } from 'k6';
import { Trend, Rate } from 'k6/metrics';

export let customLatency = new Trend('custom_http_req_duration');
export let errorRate     = new Rate('errors');

export let options = {
  stages: [
    { duration: '10s',  target: 600 },
    { duration: '10s',  target: 1000 },
    { duration: '10s',  target: 1500 },
    { duration: '10s',  target: 0 },
  ],
  thresholds: {
    errors:         ['rate<0.05'],
    http_req_duration: ['p(90)<500'],
  },
};

const TARGET = __ENV.TARGET || 'http://192.168.30.50/';

export default function () {
  let res = http.get(TARGET);
  let ok  = check(res, { 'status 200': (r) => r.status === 200 });
  errorRate.add(!ok);
  customLatency.add(res.timings.duration);
  sleep(1);
}
