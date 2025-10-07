
import { readFileSync } from 'node:fs';
import Express from '/Express.js';

const app = new Express();

const template = {
  default:readFileSync(`${import.meta.dirname}/template.default.html`).toString(),
}

const codeToError = (code, fqdn) => {
  const host = String(fqdn).toLowerCase();
  const baseError = {EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Internal Server Error', COLOUR:'red'};
  switch(code){
    case 400: return({...baseError, ERROR:'bad request'});
    case 402: return({...baseError, ERROR:'payment required', COLOUR:'blue'});
    case 403: return({...baseError, ERROR:'forbidden'});
    case 404: return({...baseError, ERROR:'not found', COLOUR:'blue'});
    case 405: return({...baseError, ERROR:'method not allowed'});
    case 406: return({...baseError, ERROR:'Not Acceptable'});
    case 407: return({...baseError, ERROR:'Proxy Authentication Required'});
    case 408: return({...baseError, ERROR:'Request Timeout', COLOUR:'blue'});
    case 409: return({...baseError, ERROR:'Conflict'});
    case 410: return({...baseError, ERROR:'Gone', COLOUR:'blue'});
    case 411: return({...baseError, ERROR:'Length Required'});
    case 412: return({...baseError, ERROR:'Precondition Failed'});
    case 413: return({...baseError, ERROR:'Content Too Large'});
    case 414: return({...baseError, ERROR:'URI Too Long'});
    case 415: return({...baseError, ERROR:'Unsupported Media Type'});
    case 416: return({...baseError, ERROR:'Range Not Satisfiable'});
    case 417: return({...baseError, ERROR:'Expectation Failed', COLOUR:'blue'});
    case 418: return({...baseError, ERROR:'I\'m a teapot', COLOUR:'orange'});
    case 421: return({...baseError, ERROR:'Misdirected Request'});
    case 422: return({...baseError, ERROR:'Unprocessable Content'});
    case 423: return({...baseError, ERROR:'Locked'});
    case 424: return({...baseError, ERROR:'Failed Dependency'});
    case 425: return({...baseError, ERROR:'Too Early'});
    case 426: return({...baseError, ERROR:'Upgrade Required'});
    case 428: return({...baseError, ERROR:'Precondition Required'});
    case 429: return({...baseError, ERROR:'Too Many Requests', COLOUR:'purple'});
    case 431: return({...baseError, ERROR:'Request Header Fields Too Large'});
    case 451: return({...baseError, ERROR:'Unavailable For Legal Reasons', COLOUR:'black'});

    case 500: return({...baseError, ERROR:'Internal Server Error'});
    case 501: return({...baseError, ERROR:'Not Implemented'});
    case 502: return({...baseError, ERROR:'Bad Gateway', COLOUR:'blue'});
    case 503: return({...baseError, ERROR:'Service Unavailable', COLOUR:'blue'});
    case 504: return({...baseError, ERROR:'Gateway Timeout', COLOUR:'blue'});
    case 505: return({...baseError, ERROR:'HTTP Version Not Supported'});
    case 506: return({...baseError, ERROR:'Variant Also Negotiates', COLOUR:'blue'});
    case 507: return({...baseError, ERROR:'Insufficient Storage'});
    case 508: return({...baseError, ERROR:'Loop Detected', COLOUR:'orange'});
    case 510: return({...baseError, ERROR:'Not Extended', COLOUR:'blue'});
    case 511: return({...baseError, ERROR:'Network Authentication Required'});
  }
  return(baseError);
}

const generateHTML = (error) => {
  let html = error.template;
  for(const k in error){
    html = html.replace(new RegExp(`\\\${${k}}`, 'ig'), error[k]);
    
  }
  return(html);
}

app.express.get('/', (req, res) => {
  console.log(req.hostname, req.path);
  const error = codeToError(404, req.hostname);
  res.status(error.CODE).end(
    generateHTML(error)
  );
});

app.express.get('/:code', (req, res) => {
  console.log(req.hostname, req.path);
  let code = parseInt(req.params.code);
  if(!Number.isInteger(code)){
    code = 500;
  }
  const error = codeToError(code,req.hostname);
  res.status(error.CODE).end(
    generateHTML(error)
  );
});

app.start();
console.log('Starting errors on port', process.env.EXPRESS_PORT || 3000);