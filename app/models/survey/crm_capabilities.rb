# frozen_string_literal: true

# CRM Capabilities: survey fields answerable by the software itself.
#
# These methods return a fixed "Oui" because the CRM inherently provides
# each capability (document storage, BO tracking, PEP screening, etc.).
# No setting_value() calls — the software IS the answer.
#
# Each method is annotated with its XBRL field ID and French label
# for traceability against the AMSF taxonomy.
#
class Survey
  module CrmCapabilities
    extend ActiveSupport::Concern

    private

    # === Client data completeness ===

    # ac1601: Est-ce que tous les éléments suivants sont conservé dans le dossier du client :
    # prénom, nom, date de naissance, lieu de naissance, nationalité, pays de résidence,
    # niveau de risque, activité du client, patrimoine
    def ac1601
      "Oui"
    end

    # ac168: Lorsque l'opération du client est effectuée par un individu, votre entité
    # consigne-t-elle les renseignements de son justificatif de domicile ?
    def ac168
      "Oui"
    end

    # ac1614: Votre entité identifie-t-elle et vérifie-t-elle ses clients à l'aide
    # d'informations fiables et indépendantes dans tous les cas de CDD ?
    def ac1614
      "Oui"
    end

    # ac1615: Les politiques CDD de votre entité incluent-elles des procédures d'acceptation
    # du client et des procédures d'identification et de vérification de l'identité du client
    # et du bénéficiaire effectif ?
    def ac1615
      "Oui"
    end

    # === BO tracking ===

    # ac1635: Lorsque l'opération est effectuée par une personne morale ou une construction
    # juridique, votre entité enregistre-t-elle les documents d'identité de tous les
    # bénéficiaires effectifs (détenant au moins 25 % de l'entité) ?
    def ac1635
      "Oui"
    end

    # ac1635a: Tous ces documents sont-ils conservés systématiquement ?
    def ac1635a
      "Oui"
    end

    # a1204o: Votre entité peut-elle distinguer les bénéficiaires effectifs qui détiennent
    # 25 % ou plus ?
    def a1204o
      "Oui"
    end

    # a1204s: Votre entité peut-elle distinguer la nationalité du bénéficiaire effectif
    # des clients ?
    def a1204s
      "Oui"
    end

    # a1203d: Votre entité enregistre-t-elle la résidence pour les bénéficiaires effectifs
    # détenant une participation de 25 % ou plus ?
    def a1203d
      "Oui"
    end

    # === Document storage ===

    # ac1625: Lorsque l'opération du client est effectuée par un individu, votre entité
    # consigne-t-elle les renseignements de sa carte d'identité ?
    def ac1625
      "Oui"
    end

    # ac1626: Lorsque l'opération du client est effectuée par un individu, votre entité
    # consigne-t-elle les renseignements de son passeport ?
    def ac1626
      "Oui"
    end

    # ac1627: Lorsque l'opération du client est effectuée par un individu, votre entité
    # consigne-t-elle les renseignements de sa carte de séjour ?
    def ac1627
      "Oui"
    end

    # ac1631: Lorsque l'opération du client est effectuée par une personne morale /
    # construction juridique, votre entité enregistre-t-elle l'extrait du registre du
    # commerce du client ?
    def ac1631
      "Oui"
    end

    # ac1633: Lorsque l'opération avec le client est effectuée par une personne morale ou
    # une construction juridique, votre entité enregistre-t-elle les statuts du client ?
    def ac1633
      "Oui"
    end

    # ac1634: Lorsque l'opération du client est effectuée par une personne morale ou une
    # construction juridique, votre entité enregistre-t-elle le procès-verbal d'assemblée ?
    def ac1634
      "Oui"
    end

    # ac1638a: Votre entité conserve-t-elle des documents récapitulatifs de tous les
    # renseignements ci-dessus ? (comme les listes consolidées)
    def ac1638a
      "Oui"
    end

    # ac1642a: Les résultats de l'outil CDD (connaissance du client) sont-ils
    # systématiquement stockés ?
    def ac1642a
      "Oui"
    end

    # === Database ===

    # ac1639a: Ces informations sont-elles dans une base de données ?
    # (comme les listes consolidées)
    def ac1639a
      "Oui"
    end

    # === CDD tools ===

    # ac1641a: Votre entité utilise-t-elle des outils pour établir la connaissance du
    # client (CDD) ?
    def ac1641a
      "Oui"
    end

    # === Risk-based approach ===

    # ac1609: Votre entité applique-t-elle une approche fondée sur le risque pour les
    # mesures de vigilance relatives à la clientèle ?
    def ac1609
      "Oui"
    end

    # ac1620: Votre entité applique-t-elle une identification et une vérification renforcées
    # de tous les clients à haut risque avant leur prise en charge ?
    def ac1620
      "Oui"
    end

    # === Source of wealth ===

    # ac1617: Votre entité examine-t-elle la source du patrimoine avant l'entrée en
    # relation ?
    def ac1617
      "Oui"
    end

    # === Record retention ===

    # ac11101: Votre entité conserve-t-elle les informations relatives aux opérations
    # pendant au moins 5 ans ?
    def ac11101
      "Oui"
    end

    # ac11102: Votre entité conserve-t-elle toutes les correspondances relatives aux CDD et
    # les correspondances commerciales pendant au moins 5 ans après la fin d'une relation
    # client ?
    def ac11102
      "Oui"
    end

    # ac11103: Votre entité conserve-t-elle ces informations et documents dans un endroit
    # sûr et sécurisé ?
    def ac11103
      "Oui"
    end

    # ac11104: Ces informations et documents sont-ils rapidement mis à la disposition des
    # autorités compétentes sur demande ?
    def ac11104
      "Oui"
    end

    # ac11105: Votre entité dispose-t-elle de sauvegardes des informations relatives aux CDD
    # et aux correspondances commerciales avec un plan de récupération des données ?
    def ac11105
      "Oui"
    end

    # === Data accessibility ===

    # ac1608: Les données concernant les anciennes relations clients sont-elles accessibles
    # sur demande par l'AMSF ? (5 années)
    def ac1608
      "Oui"
    end

    # === PEP screening ===

    # ac11301: Votre entité prend-elle des mesures pour déterminer si les clients et les
    # bénéficiaires effectifs sont des personnes politiquement exposées (PPE) ?
    def ac11301
      "Oui"
    end

    # ac11304: Un filtrage des PPE est-t-il effectué dans le cadre du processus de CDD pour
    # les nouveaux clients ?
    def ac11304
      "Oui"
    end

    # ac11306: Les PPE font-elles l'objet d'une surveillance accrue ?
    def ac11306
      "Oui"
    end

    # === Documented procedures ===

    # ac1201: Votre entité a-t-elle préparé un ensemble de politiques et procédures de
    # LBC/FT documenté ?
    def ac1201
      "Oui"
    end

    # === Client distinction ===

    # a155: Votre entité distingue-t-elle si les clients sont des personnes morales
    # monégasques et le type de personne morale ?
    def a155
      "Oui"
    end

    # a3402: Votre entité peut-elle distinguer si un prospect (client potentiel) a été rejeté
    # en raison d'un attribut / activité / déficience du client ou principalement en raison de
    # la pratique discrétionnaire de LBC/FT-P de l'entité ?
    def a3402
      "Oui"
    end

    # a3415: Votre entité peut-elle distinguer si une relation d'affaires a été résiliée en
    # raison d'un attribut / activité / déficience du client ou principalement en raison de la
    # pratique discrétionnaire de LBC/FT-P de l'entité ?
    def a3415
      "Oui"
    end

    # a2113b: Votre entité peut-elle distinguer les opérations en espèces supérieures à
    # 100 000 euros dans votre comptabilité ? (opérations par le client)
    def a2113b
      "Oui"
    end

    # a2113w: Votre entité peut-elle distinguer les opérations en espèces supérieures à
    # 100 000 euros dans votre comptabilité ? (opérations avec le client)
    def a2113w
      "Oui"
    end
  end
end
