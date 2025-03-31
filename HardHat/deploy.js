(async () => {
  try{
    const Spacebear = await hre.ethers.getContractFactory("Spacebear");

    const spacebearInstance = await Spacebear.deploy();

    await spacebearInstance.waitForDeployment();

    console.log(`Deploy contract at ${spacebearInstance.address}`);

  } catch(e) {
    console.error(e);
    process.exitCode = 1;
  }
})()
