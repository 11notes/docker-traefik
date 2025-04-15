
const { readFileSync } = require('node:fs');
const Express = require('/Express');
const app = new Express();

const template = {
  default:readFileSync(`${__dirname}/template.default.html`).toString(),
}

const codeToError = (code, fqdn) => {
  const host = String(fqdn).toLowerCase();
  switch(code){
    case 400: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'bad request', COLOUR:'red'});
    case 402: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'payment required', COLOUR:'blue'});
    case 403: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'forbidden', COLOUR:'red'});
    case 404: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'not found', COLOUR:'blue'});
    case 405: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'method not allowed', COLOUR:'red'});
    case 406: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Not Acceptable', COLOUR:'red'});
    case 407: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Proxy Authentication Required', COLOUR:'red'});
    case 408: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Request Timeout', COLOUR:'blue'});
    case 409: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Conflict', COLOUR:'red'});
    case 410: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Gone', COLOUR:'blue'});
    case 411: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Length Required', COLOUR:'red'});
    case 412: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Precondition Failed', COLOUR:'red'});
    case 413: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Content Too Large', COLOUR:'red'});
    case 414: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'URI Too Long', COLOUR:'red'});
    case 415: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Unsupported Media Type', COLOUR:'red'});
    case 416: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Range Not Satisfiable', COLOUR:'red'});
    case 417: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Expectation Failed', COLOUR:'blue'});
    case 418: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'I\'m a teapot', COLOUR:'orange'});
    case 421: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Misdirected Request', COLOUR:'red'});
    case 422: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Unprocessable Content', COLOUR:'red'});
    case 423: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Locked', COLOUR:'red'});
    case 424: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Failed Dependency', COLOUR:'red'});
    case 425: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Too Early', COLOUR:'red'});
    case 426: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Upgrade Required', COLOUR:'red'});
    case 428: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Precondition Required', COLOUR:'red'});
    case 429: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Too Many Requests', COLOUR:'purple'});
    case 431: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Request Header Fields Too Large', COLOUR:'red'});
    case 451: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Unavailable For Legal Reasons', COLOUR:'black'});

    case 500: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Internal Server Error', COLOUR:'red'});
    case 501: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Not Implemented', COLOUR:'red'});
    case 502: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Bad Gateway', COLOUR:'blue'});
    case 503: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Service Unavailable', COLOUR:'blue'});
    case 504: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Gateway Timeout', COLOUR:'blue'});
    case 505: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'HTTP Version Not Supported', COLOUR:'red'});
    case 506: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Variant Also Negotiates', COLOUR:'blue'});
    case 507: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Insufficient Storage', COLOUR:'red'});
    case 508: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Loop Detected', COLOUR:'orange'});
    case 510: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Not Extended', COLOUR:'blue'});
    case 511: return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:code, ERROR:'Network Authentication Required', COLOUR:'red'});
  }
  return({EXPRESS_ERROR_TITLE:process.env?.EXPRESS_ERROR_TITLE, template:template.default, FQDN:host, CODE:500, ERROR:'Internal Server Error', COLOUR:'red'});
}

const generateHTML = (error) => {
  let html = error.template;
  for(const k in error){
    html = html.replace(new RegExp(`\\\${${k}}`, 'ig'), error[k]);
    
  }
  return(html);
}

app.express.get('/', (req, res, next) => {
  console.log(req.hostname, req.path);
  const error = codeToError(404, req.hostname);
  res.status(error.CODE).end(
    generateHTML(error)
  );
});

app.express.get('/:code', (req, res, next) => {
  console.log(req.hostname, req.path);
  let code = 500;
  if(Number.isInteger(parseInt(req.params.code))){
    code = parseInt(req.params.code);
  }
  const error = codeToError(code,req.hostname);
  res.status(error.CODE).end(
    generateHTML(error)
  );
});

app.start();
console.log('starting errors');