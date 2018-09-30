using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Threading.Tasks;

//using AnE.ExP.Core.Client.Constants;
//using AnE.ExP.Core.Client.Exceptions;
//using AnE.ExP.Core.ConfigurationUtil;

using Microsoft.Bing.Experimentation.ExpMan.Contract;
using Microsoft.ExP.API.Client;
using Microsoft.ExP.API.Contract;
using Microsoft.ExP.API.MasterData;
using Newtonsoft.Json;

using Experiment = Microsoft.ExP.API.Contract.V2.Experiment;
using HttpClientFactory = Microsoft.ExP.Common.HttpClient.HttpClientFactory;

namespace ExpAPI
{
    class Program
    {
        static void Main(string[] args)
        {
            string _baseUrl = "https://exp.microsoft.com/api/";
            HttpClient _httpClient = HttpClientFactory.GetAADHttpClient(_baseUrl, resourceId: _baseUrl.Replace("api/", ""));
            //FlightManagementClient fmClient = new FlightManagementClient(_httpClient);
            //FlightConfiguration fmCfg= fmClient.GetFlightAsync("searchvnext").Result;
            //Console.WriteLine(fmCfg.Description);
            var expMan = new ExperimentManagementClient(_httpClient);
            ExperimentQuery experimentQuery = new ExperimentQuery();
           // experimentQuery.Flight = new string[] { "17513912V2C" };
            experimentQuery.ManagementGroup = new string[] { "/MSN/ustf - sfw" };
            experimentQuery.BudgetArea = new string[] { "ustf - sfw" };
            experimentQuery.State = new string[] {"Running" };
            var details=expMan.SearchExperimentsAsync(experimentQuery).Result;
            Console.WriteLine($"Total Running experiments:{details.Results.Count()}");
            foreach(var r in details.Results)
            {
                Console.WriteLine($"{r.Name}  -{ r.Extensions["VsLink"]}");

            }
            Console.WriteLine("");
        }
    }
}
